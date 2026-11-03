---
name: Lua Literal Proofs
description: Use when writing or validating .refine proofs; explains the restricted table-literal format, required keys, and data-only rule.
---

# Lua Literal Proofs

## Rule

A proof is a restricted Lua table literal, parsed by `lib/literal.lua`.
It is never executed.

Allowed: strings, integers, booleans, tables, comments.
Rejected: calls, concatenation, long strings, `nil`, duplicate keys.

## Required shape

```lua
return {
  refinement = "name",
  spec = {
    input = "...",
    output = "...",
    precondition = { "..." },
    postcondition = { "..." },
    failure = { "..." },
    safety = { "..." },
    determinism = true,
    resource_bound = "...",
    liveness = "...",
  },
  implementation = { language = "awk", entrypoint = "awk/x.awk" },
  checks = { "tests/contract/x.sh" },
}
```

## Check

```sh
cd ~/.local/src/dotfiles/framework
lua5.4 tests/proofs.lua proofs/*.refine
```
