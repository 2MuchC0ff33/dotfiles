---
name: nushell-config-completions-partial
description: Description
compatibility: opencode
---

# nushell-config-completions-partial

## Description
Disable partial matching in completions, relying solely on the fuzzy algorithm for flexible but precise matching.

## When to Load
Load this skill when configuring `$env.config.completions.partial` in `config.nu`.

## Source
STANDARDS.adoc §11.1 (line 3672)

## Key Rules

- MANDATE: `$env.config.completions.partial` MUST be `false`.
- SHOULD: With `partial: false`, Nushell does NOT match partial substrings independently of the fuzzy algorithm. This avoids redundant or overly broad completion candidates.
- FORBIDDEN: `partial: true` when `algorithm: "fuzzy"` is already set — this creates redundant matching (fuzzy already covers partial) and can produce too many low-relevance candidates.

## Rationale

The `partial` setting controls whether completions match any substring within
a candidate. When `algorithm: "fuzzy"` is active (as required by
[nushell-config-completions-fuzzy](file://.opencode/skills/nushell-config-completions-fuzzy.md)),
fuzzy matching already handles:
- **Substring matching**: Characters can appear in any position
- **Non-sequential matching**: Typed chars need not be contiguous in the target
- **Transposition tolerance**: Small typos still produce matches

Enabling `partial: true` on top of fuzzy adds a second, redundant matching
pass that can:
- Duplicate candidates (same entry matched by both algorithms)
- Increase noise with too many loosely-matched completions
- Reduce the signal-to-noise ratio of the completion menu

With fuzzy as the sole matching strategy, you get the best of both worlds:
flexible matching without duplicate or overly broad results.

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
- [nushell-config-completions-quick](file://.opencode/skills/nushell-config-completions-quick.md)
