#!/bin/bash
input=$(cat)

PYTHON=$(command -v python3 || command -v python || true)
[ -z "$PYTHON" ] && { echo "statusline: python required" >&2; exit 1; }

parsed=$(printf '%s' "$input" | "$PYTHON" -c "
import sys, json, os
d = json.load(sys.stdin)
pct = int(d.get('context_window', {}).get('used_percentage', 0))
model = d.get('model', {}).get('display_name', '')
proj = os.path.basename(d.get('workspace', {}).get('project_dir', ''))
print(pct, model, proj, sep='\t')
")
IFS=$'\t' read -r CONTEXT_WINDOW_USED_PERCENTAGE MODEL_DISPLAY_NAME WORKSPACE_PROJECT_DIR <<< "$parsed"

GIT_BRANCH=""
if git rev-parse --git-dir > /dev/null 2>&1; then
    BRANCH=$(git branch --show-current 2>/dev/null)
    [ -n "$BRANCH" ] && GIT_BRANCH=" | 🌿 $BRANCH"
fi

echo "🧠 ${CONTEXT_WINDOW_USED_PERCENTAGE}% | 🤖 $MODEL_DISPLAY_NAME | 📁 $WORKSPACE_PROJECT_DIR${GIT_BRANCH}"
