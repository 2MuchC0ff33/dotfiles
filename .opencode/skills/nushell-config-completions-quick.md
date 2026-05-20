# nushell-config-completions-quick

## Description
Disable "quick" completion mode to ensure full, accurate completions rather than abbreviated or "short-circuit" matches.

## When to Load
Load this skill when configuring `$env.config.completions.quick` in `config.nu`.

## Source
STANDARDS.adoc §11.1 (line 3671)

## Key Rules

- MANDATE: `$env.config.completions.quick` MUST be `false`.
- SHOULD: With `quick: false`, Nushell does NOT attempt to short-circuit completion with a single "best guess" — it shows the full list of candidates.
- FORBIDDEN: `quick: true` — this auto-selects the first match without showing alternatives, which can silently insert the wrong completion.

## Rationale

The `quick` completion setting controls whether Nushell automatically commits
to the first matching completion without showing a menu. When `quick: true`:

1. You press Tab
2. Nushell finds fuzzy/prefix matches
3. If there's exactly one match OR if the first match seems "obvious"
4. It inserts the completion immediately without a menu

This sounds efficient but is error-prone:
- **False certainty**: You think "it completed correctly" but the first match
  might not be what you intended
- **No discovery**: You miss seeing other valid completions you didn't know about
- **Inconsistency**: Sometimes it shows a menu, sometimes it doesn't

With `quick: false`, Nushell always shows the completion menu, giving you
full control over which candidate to accept.

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
- [nushell-config-completions-fuzzy](file://.opencode/skills/nushell-config-completions-fuzzy.md)
- [nushell-config-completions-case-sensitive](file://.opencode/skills/nushell-config-completions-case-sensitive.md)
- [nushell-config-completions-partial](file://.opencode/skills/nushell-config-completions-partial.md)
