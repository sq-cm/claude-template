#!/usr/bin/env python3
"""
google-oauth-setup.py — one-shot OAuth credential minter for Google Search
Console + GA4 MCP integrations (analytics-mcp, gsc).

Reads GOOGLE_CLIENT_ID / GOOGLE_CLIENT_SECRET (and optionally
GOOGLE_PROJECT_ID) from the vault-root .env, runs the installed-app OAuth
consent flow in a browser, and writes an authorized_user credential file to
%USERPROFILE%\\.config\\claude-google\\adc.json for the MCP servers declared
in your own .mcp.json (copied from .mcp.json.example) to pick up.

Run from the vault root:
    uv run --python 3.12 --with google-auth-oauthlib "Vault/Scripts/google-oauth-setup.py"

Re-run this script any time the refresh token needs to be re-minted. This
OAuth client is published to Production (not left in Testing mode, where
Google expires refresh tokens after just 7 days) — a Production refresh
token only dies if left unused for roughly six months, at which point
re-running this script mints a fresh one.

The credential file is written owner-only (0600, directory 0700) on
macOS/Linux; a re-mint replaces the previous token — rotate it (re-run this
script) if the file was ever copied or shared.
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
    project_id = get_setting(env_values, "GOOGLE_PROJECT_ID")

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

    output_dir = Path.home() / ".config" / "claude-google"
    output_path = output_dir / "adc.json"
    output_dir.mkdir(mode=0o700, parents=True, exist_ok=True)
    if os.name != "nt":
        # mkdir's mode only applies when it creates the directory; tighten an
        # existing one too. Skipped on Windows, where the profile ACL already
        # protects this path and POSIX mode bits don't map to NTFS.
        os.chmod(output_dir, 0o700)

    credential_payload = {
        "type": "authorized_user",
        "client_id": client_id,
        "client_secret": client_secret,
        "refresh_token": creds.refresh_token,
    }
    # GOOGLE_PROJECT_ID is optional (.env.example). Without it, Google
    # attributes quota for these user credentials to the OAuth client's own
    # project, so write the field only when the user chose one — never a
    # project this clone doesn't own.
    if project_id:
        credential_payload["quota_project_id"] = project_id
    else:
        print(
            "NOTE: GOOGLE_PROJECT_ID is not set, so no quota project was written. "
            "If a GA4 or Search Console call fails asking for a quota project, "
            "set GOOGLE_PROJECT_ID in .env and re-run this script.",
            file=sys.stderr,
        )

    # The file holds the client secret and a long-lived refresh token, so it
    # must never be group- or world-readable. O_CREAT's mode only applies to a
    # new file; fchmod tightens a pre-existing one before any bytes are written.
    fd = os.open(output_path, os.O_WRONLY | os.O_CREAT | os.O_TRUNC, 0o600)
    if os.name != "nt":
        os.fchmod(fd, 0o600)
    with os.fdopen(fd, "w", encoding="utf-8") as handle:
        handle.write(json.dumps(credential_payload, indent=2))

    print(f"Credential written to: {output_path}")
    print("Google OAuth setup complete — GSC and GA4 MCP servers are ready to authenticate.")


if __name__ == "__main__":
    main()
