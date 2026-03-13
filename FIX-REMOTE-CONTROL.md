# Fix Claude Code Remote Control Trust Error

## Handoff Prompt — Paste this into Claude on your Mac:

---

Fix my `claude remote-control` "Workspace not trusted" error. The trust state is stored in `~/.claude.json` (NOT `~/.claude/settings.json`). Do the following:

1. Read `~/.claude.json`
2. Add a `projects` key (or merge into existing) with my home directory as a sub-key containing `"hasTrustDialogAccepted": true` and `"hasTrustDialogHooksAccepted": true`. My home dir is `/Users/draxtoshi`.
3. Read `~/.claude/settings.json` and remove the `trustedDirectories` key if it exists — it's not a real setting.
4. Verify both files look correct.

Example of what the projects entry should look like in `~/.claude.json`:
```json
"projects": {
  "/Users/draxtoshi": {
    "hasTrustDialogAccepted": true,
    "hasTrustDialogHooksAccepted": true
  }
}
```

Then run `claude remote-control` to confirm it works.

---

## Manual fallback (one-liner for Mac terminal):

```bash
python3 -c "
import json, os
p = os.path.expanduser('~/.claude.json')
d = json.load(open(p)) if os.path.exists(p) else {}
d.setdefault('projects', {}).setdefault(os.path.expanduser('~'), {}).update({'hasTrustDialogAccepted': True, 'hasTrustDialogHooksAccepted': True})
json.dump(d, open(p, 'w'), indent=2)
print('Fixed! Now run: claude remote-control')
"
```
