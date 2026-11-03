---
name: POSIX Audit Rules
description: Use when adding or debugging a banned-option rule; explains scopes, pattern syntax, self-exemption, and negative tests.
---

# POSIX Audit Rules

## Source

`etc/banned_options.txt` has five tab-separated fields:
`id`, `scope`, `pattern`, `class`, `reason`.

Scopes: `all`, `lua`, `lib`, `sh`, `awk`, `sql`, `make`, `c`.

## Rules

- Patterns are POSIX ERE.
- `sh/tests/posix_scope_audit.sh` excludes itself and `tests/contract/`.
- `tests/integration/` is scanned.
- A new rule needs a negative test.
- Do not weaken a rule to silence a false positive; fix the pattern.

## Check

```sh
cd ~/.local/src/dotfiles/framework
make audit
```

Inject a violation and confirm exit 3:

```sh
printf '#!/bin/sh\nlocal x=1\n' > sh/tests/_bad.sh
set +e; make audit; rc=$?; set -e
rm -f sh/tests/_bad.sh
[ "$rc" -eq 3 ]
```
