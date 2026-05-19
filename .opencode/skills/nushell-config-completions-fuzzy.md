# nushell-config-completions-fuzzy

## Description
Use fuzzy matching algorithm for tab completions, accepting matches even when characters are not strictly sequential.

## When to Load
Load this skill when configuring `$env.config.completions.algorithm` in `config.nu`.

## Source
STANDARDS.adoc §11.1 (line 3615)

## Key Rules

- MANDATE: `$env.config.completions.algorithm` MUST be `"fuzzy"`.
- SHOULD: Fuzzy matching allows completions even when the typed characters are not strictly prefix-matching. For example, typing `cbt` could match `cargo build --target`.
- FORBIDDEN: `algorithm: "prefix"` (only matches strict prefixes) or `algorithm: "partial"` (matches substrings but doesn't handle transpositions/typos).

## Rationale

Fuzzy completion dramatically improves the developer experience by finding
relevant results even with typos, abbreviations, or non-sequential typing:

- **Abbreviation matching**: `cbt` → `cargo build --target`
- **Typo tolerance**: `cargo bild` → `cargo build`
- **Subsequence matching**: `gc` → `git commit`
- **Scoring**: Results are ranked by edit distance, so the best match appears first

This is the same algorithm powering Sublime Text's "fuzzy" search, VS Code's
command palette, and Telescope in Neovim. Once you get used to fuzzy
completions, prefix-only matching feels painfully restrictive.

## Example

```nushell
$env.config = {
    completions: {
        case_sensitive: true
        quick:          false
        partial:        false
        algorithm:      "fuzzy"
    }
}
```

## Related Skills
- [nushell-config-completions-case-sensitive](file://.opencode/skills/nushell-config-completions-case-sensitive.md)
- [nushell-config-completions-quick](file://.opencode/skills/nushell-config-completions-quick.md)
- [nushell-config-completions-partial](file://.opencode/skills/nushell-config-completions-partial.md)
