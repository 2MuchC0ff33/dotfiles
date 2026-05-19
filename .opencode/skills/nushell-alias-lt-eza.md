# nushell-alias-lt-eza

## Description
Define `lt` alias for an eza tree view: `eza --tree --git --icons --level=3`.

## When to Load
Load this skill when reviewing or creating Nushell aliases in `config.nu`.

## Source
STANDARDS.adoc §11.1 (line 3634)

## Key Rules

- MANDATE: `alias lt = eza --tree --git --icons --level=3` MUST be present in `config.nu`.
- SHOULD: `lt` renders the directory structure as a tree, 3 levels deep, with git status and icons.
- FORBIDDEN: Omitting this alias, or using Nushell's built-in recursive listing instead of eza's tree view.

## Rationale

`lt` is a tree-view command that complements `ls` (flat list) and `ll` (list
with hidden files). It uses:

- `--tree`: Render directory hierarchy with tree-drawing characters (├── └──)
- `--git`: Show git status per file in the tree
- `--icons`: File-type icons per entry
- `--level=3`: Limit depth to 3 levels to avoid overwhelming output

The 3-level depth limit prevents the tree from becoming enormous in
deeply-nested project trees (like `node_modules` or `target`). For deeper
exploration, use `lt` in a specific subdirectory.

## Example

```nushell
alias lt = eza --tree --git --icons --level=3
```

Typical output:
```
.
├── Cargo.toml
├── src/
│   ├── main.rs
│   ├── lib.rs
│   └── cli/
│       ├── mod.rs
│       └── args.rs
└── config/
    ├── nushell/
    │   └── config.nu
    └── helix/
        └── config.toml
```

## Related Skills
- [nushell-alias-ls-eza](file://.opencode/skills/nushell-alias-ls-eza.md)
- [nushell-alias-ll-eza](file://.opencode/skills/nushell-alias-ll-eza.md)
