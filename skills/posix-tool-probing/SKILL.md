---
name: POSIX Tool Probing
description: Use when a gate fails on tool versions or a new host is being prepared; covers env_probe.sh, tool_versions.txt, and probe functions.
---

# POSIX Tool Probing

## Files

- `etc/tool_versions.txt`: `tool`, `expected_ere`, `tier`, `probe`.
- `sh/tests/env_probe.sh`: probe functions and version matching.

## Tiers

- `REQUIRED`: failure exits 4.
- `C_REQUIRED`: warning unless `FW_REQUIRE_C=1`.
- `OPTIONAL`: warning only.

## Check

```sh
cd ~/.local/src/dotfiles/framework
sh/tests/env_probe.sh
getconf _POSIX_VERSION
```

## Adding a probe

1. Add `probe_<name>()` to `env_probe.sh`.
2. Add a tab-separated row to `tool_versions.txt`.
3. Keep the expected ERE anchored enough to catch drift.
