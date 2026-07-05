#!/usr/bin/env python3
"""
google-oauth-setup.py — one-shot OAuth credential minter for Google Search
Console + GA4 MCP integrations (analytics-mcp, gsc).

Reads GOOGLE_CLIENT_ID / GOOGLE_CLIENT_SECRET (and optionally
GOOGLE_PROJECT_ID) from the vault-root .env, runs the installed-app OAuth
consent flow in a browser, and writes an authorized_user credential file to
%USERPROFILE%\\.config\\claude-google\\adc.json for the MCP servers declared
in .mcp.json to pick up.

Run from the vault root:
    uv run --python 3.12 --with google-auth-oauthlib "Vault/Scripts/google-oauth-setup.py"

Re-run this script any time the refresh token needs to be re-minted. This
OAuth client is published to Production (not left in Testing mode, where
Google expires refresh tokens after just 7 days) — a Production refresh
token only dies if left unused for roughly six months, at which point
re-running this script mints a fresh one.
"""

from __future__ import annotations

import os
import sys
import json
from pathlib import Path

try:
    from google_auth_oauthlib.flow import InstalledAppFlow
except ImportError:
    print(
        "ERROR: google-auth-oauthlib is not installed. Run this script with "
        "uv as documented in the header comment (uv run --with google-auth-oauthlib ...).",
        file=sys.stderr,
    )
    sys.exit(1)

SCOPES = [
    "https://www.googleapis.com/auth/analytics.readonly",
    "https://www.googleapis.com/auth/webmasters.readonly",
]

DEFAULT_PROJECT_ID = "sq-claude-integrations"

# Vault root is two levels up from this script (Vault/Scripts/ -> vault root).
VAULT_ROOT = Path(__file__).resolve().parent.parent.parent
ENV_PATH = VAULT_ROOT / ".env"


def _strip_quotes(value: str) -> str:
    value = value.strip()
    if len(value) >= 2 and value[0] == value[-1] and value[0] in ("'", '"'):
        return value[1:-1]
    return value


def load_env_file(path: Path) -> dict[str, str]:
    """Simple KEY=VALUE parser: ignores comments and blank lines, strips quotes."""
    values: dict[str, str] = {}
    if not path.exists():
        return values

    for raw_line in path.read_text(encoding="utf-8").splitlines():
        line = raw_line.strip()
        if not line or line.startswith("#"):
            continue
        if "=" not in line:
            continue
        key, _, value = line.partition("=")
        values[key.strip()] = _strip_quotes(value)

    return values


def get_setting(env_values: dict[str, str], key: str, default: str | None = None) -> str | None:
    """.env file takes precedence, falling back to an actual environment variable."""
    if key in env_values and env_values[key]:
        return env_values[key]
    return os.environ.get(key, default)


def main() -> None:
    env_values = load_env_file(ENV_PATH)

    client_id = get_setting(env_values, "GOOGLE_CLIENT_ID")
    client_secret = get_setting(env_values, "GOOGLE_CLIENT_SECRET")
    project_id = get_setting(env_values, "GOOGLE_PROJECT_ID", DEFAULT_PROJECT_ID)

    if not client_id or not client_secret:
        print(
            "ERROR: GOOGLE_CLIENT_ID and/or GOOGLE_CLIENT_SECRET are missing. "
            f"Set them in {ENV_PATH} or as environment variables before running this script.",
            file=sys.stderr,
        )
        sys.exit(1)

    client_config = {
        "installed": {
            "client_id": client_id,
            "client_secret": client_secret,
            "auth_uri": "https://accounts.google.com/o/oauth2/auth",
            "token_uri": "https://oauth2.googleapis.com/token",
            "redirect_uris": ["http://localhost"],
        }
    }

    flow = InstalledAppFlow.from_client_config(client_config, scopes=SCOPES)

    # prompt="consent" forces Google to re-issue a refresh token even when
    # this client has already been authorised before — without it, a re-run
    # can silently return no refresh_token at all.
    creds = flow.run_local_server(port=0, prompt="consent")

    if not creds.refresh_token:
        print(
            "ERROR: OAuth flow completed but no refresh_token was returned. "
            "Revoke prior access at https://myaccount.google.com/permissions and re-run this script.",
            file=sys.stderr,
        )
        sys.exit(1)

    output_path = Path.home() / ".config" / "claude-google" / "adc.json"
    output_path.parent.mkdir(parents=True, exist_ok=True)

    credential_payload = {
        "type": "authorized_user",
        "client_id": client_id,
        "client_secret": client_secret,
        "refresh_token": creds.refresh_token,
        "quota_project_id": project_id,
    }

    output_path.write_text(json.dumps(credential_payload, indent=2), encoding="utf-8")

    print(f"Credential written to: {output_path}")
    print("Google OAuth setup complete — GSC and GA4 MCP servers are ready to authenticate.")


if __name__ == "__main__":
    main()
