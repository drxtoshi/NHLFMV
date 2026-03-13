#!/bin/bash
# Fix Claude Code "Workspace not trusted" error for remote-control
# Run this script on your Mac: bash fix-remote-control-trust.sh

set -e

CLAUDE_JSON="$HOME/.claude.json"
SETTINGS_JSON="$HOME/.claude/settings.json"
HOME_DIR="$HOME"

echo "=== Claude Code Remote Control Trust Fix ==="
echo ""

# Step 1: Fix ~/.claude.json - add trust flags for home directory
echo "[1/3] Fixing workspace trust in ~/.claude.json..."

if [ -f "$CLAUDE_JSON" ]; then
    # Check if jq is available
    if command -v jq &> /dev/null; then
        # Use jq to safely merge trust flags
        TEMP_FILE=$(mktemp)
        jq --arg dir "$HOME_DIR" '
            .projects[$dir] = ((.projects[$dir] // {}) + {
                "hasTrustDialogAccepted": true,
                "hasTrustDialogHooksAccepted": true
            })
        ' "$CLAUDE_JSON" > "$TEMP_FILE" && mv "$TEMP_FILE" "$CLAUDE_JSON"
        echo "  ✓ Added trust flags for $HOME_DIR"
    else
        # Fallback: use python3 (available on macOS by default)
        python3 -c "
import json, os, sys

path = os.path.expanduser('~/.claude.json')
home = os.path.expanduser('~')

with open(path, 'r') as f:
    data = json.load(f)

if 'projects' not in data:
    data['projects'] = {}

if home not in data['projects']:
    data['projects'][home] = {}

data['projects'][home]['hasTrustDialogAccepted'] = True
data['projects'][home]['hasTrustDialogHooksAccepted'] = True

with open(path, 'w') as f:
    json.dump(data, f, indent=2)

print(f'  ✓ Added trust flags for {home}')
"
    fi
else
    # Create the file from scratch
    if command -v jq &> /dev/null; then
        jq -n --arg dir "$HOME_DIR" '{
            projects: {
                ($dir): {
                    hasTrustDialogAccepted: true,
                    hasTrustDialogHooksAccepted: true
                }
            }
        }' > "$CLAUDE_JSON"
    else
        python3 -c "
import json, os

home = os.path.expanduser('~')
data = {
    'projects': {
        home: {
            'hasTrustDialogAccepted': True,
            'hasTrustDialogHooksAccepted': True
        }
    }
}

with open(os.path.expanduser('~/.claude.json'), 'w') as f:
    json.dump(data, f, indent=2)

print(f'  ✓ Created ~/.claude.json with trust flags for {home}')
"
    fi
fi

# Step 2: Clean up invalid trustedDirectories from settings.json
echo "[2/3] Cleaning up ~/.claude/settings.json..."

if [ -f "$SETTINGS_JSON" ]; then
    if command -v jq &> /dev/null; then
        TEMP_FILE=$(mktemp)
        jq 'del(.trustedDirectories)' "$SETTINGS_JSON" > "$TEMP_FILE" && mv "$TEMP_FILE" "$SETTINGS_JSON"
        echo "  ✓ Removed invalid 'trustedDirectories' key (not a real setting)"
    else
        python3 -c "
import json, os

path = os.path.expanduser('~/.claude/settings.json')
with open(path, 'r') as f:
    data = json.load(f)

if 'trustedDirectories' in data:
    del data['trustedDirectories']

with open(path, 'w') as f:
    json.dump(data, f, indent=2)

print(\"  ✓ Removed invalid 'trustedDirectories' key (not a real setting)\")
"
    fi
else
    echo "  - No settings.json found, skipping"
fi

# Step 3: Verify
echo "[3/3] Verifying..."
echo ""

if [ -f "$CLAUDE_JSON" ]; then
    echo "~/.claude.json trust entries:"
    if command -v jq &> /dev/null; then
        jq --arg dir "$HOME_DIR" '.projects[$dir]' "$CLAUDE_JSON"
    else
        python3 -c "
import json, os
with open(os.path.expanduser('~/.claude.json')) as f:
    data = json.load(f)
home = os.path.expanduser('~')
print(json.dumps(data.get('projects', {}).get(home, {}), indent=2))
"
    fi
fi

echo ""
echo "=== Done! Now try: claude remote-control ==="
echo ""
echo "If it still fails, try running from a project directory instead:"
echo "  cd ~/some-project && claude remote-control"
