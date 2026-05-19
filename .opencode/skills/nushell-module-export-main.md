# Export Def Main

## Description
Use `export def main` when the command name matches the module filename for idiomatic module entry points.

## When to Load
Load this skill when creating a Nushell module with a primary entry point.

## Source
STANDARDS.adoc §11.5.6 (lines 4188–4193, 4209–4222)

## Key Rules

- MANDATE: `export def main` when command name matches module filename
- MANDATE: ONLY necessary definitions are `export`-ed

## Rationale

When a module file is loaded with `use my-module.nu`, the `main` command becomes directly accessible. This follows the convention that `my-module.nu` has a `main` operation. `use my-module.nu` without submodule syntax invokes `main`.

## Example

```nu
# my-module.nu — CORRECT module pattern
export def main [] {                # main = module name
    do-setup
    do-work
}

def do-setup [] {                   # private — not exported
    print 'setup complete'
}

export def do-work [] {             # public — exported
    # ...
}

# INCORRECT — different name from convention
# File: build.nu
export def run-build [] { ... }     # should be `export def main []`

# INCORRECT — no main at all (if single-command module)
# File: greet.nu
export def greet [name: string] { ... }
# Should be `export def main` since the file is greet.nu and there's only one command
```
