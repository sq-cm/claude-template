---
name: mempalace-init
description: Use when setting up MemPalace for the first time, configuring the palace for a new directory, or troubleshooting mempalace installation.
---

# MemPalace Init

Guide the user through a complete MemPalace setup. Follow each step in order,
stopping to report errors and attempt remediation before proceeding.

## Step 1: Check Python version

Run `python --version` and confirm the version is 3.9 or higher. If Python is not found or the version is too old, tell the user they need Python 3.9+ installed and stop.

## Step 2: Check if mempalace is already installed

Run `pip show mempalace` to see if the package is already present. If it is, report the installed version and skip to Step 4.

## Step 3: Install mempalace

Run `pip install mempalace`.

If `pip install mempalace` fails, try these fallbacks in order:
1. `pip3 install mempalace`
2. `python -m pip install mempalace`
3. If missing build tools: suggest installing Microsoft C++ Build Tools from https://visualstudio.microsoft.com/visual-cpp-build-tools/ then retry.
4. If all fail, report clearly and stop.

## Step 4: Ask for project directory

Ask the user which project directory they want to initialize with MemPalace. Offer the current working directory as the default. Wait for their response before continuing.

## Step 5: Initialize the palace

Run `PYTHONUTF8=1 python -m mempalace init --yes <dir>` where `<dir>` is the directory from Step 4.

If this fails, report the error and stop.

## Step 6: Configure MCP server

Run:

    claude mcp add --scope project mempalace -- python -m mempalace.mcp_server

If this fails, report the error but continue (MCP can be configured manually later).

## Step 7: Verify installation

Run `PYTHONUTF8=1 python -m mempalace status` and confirm the output shows a healthy palace.

## Step 8: Show next steps

Tell the user setup is complete and suggest:
- Use /mempalace:mine to start adding data
- Use /mempalace:search to query stored knowledge
