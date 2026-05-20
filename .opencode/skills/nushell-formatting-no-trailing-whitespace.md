# Nushell Formatting: No Trailing Whitespace

## Description
No trailing whitespace is permitted on any line in any `.nu` source file.

## When to Load
Load this skill when editing any `.nu` file, configuring editor settings for Nushell development, setting up lint/format tools, or reviewing diffs before commit.

## Source
STANDARDS.adoc §11.5.2 (lines 4061–4123)

## Key Rules

- MANDATE: Every line in a `.nu` file MUST end at the last non-whitespace character (or be completely empty).
- MANDATE: Empty lines MUST contain zero characters (no spaces, no tabs).
- FORBIDDEN: Trailing spaces at the end of any line.
- FORBIDDEN: Trailing tabs at the end of any line.
- FORBIDDEN: Lines that appear non-empty but consist only of whitespace.

## Rationale

1. Trailing whitespace creates noise in diffs — every editor that strips it will show changes on lines that were not semantically modified.
2. Trailing whitespace can cause CI failures in lint steps and is considered unprofessional in committed code.
3. Most modern editors have "trim trailing whitespace on save" functionality; this standard mandates its use.
4. Lines with only whitespace are invisible in most editors but produce visible blank lines with hidden characters in diffs.

## Editor Configuration

### Helix (config/helix/config.toml)

```toml
[editor]
trim-trailing-whitespace = true
```

### VS Code

```json
"files.trimTrailingWhitespace": true
```

### IntelliJ

Enable: Settings → Editor → General → "Strip trailing spaces on save" → "All"

## Detection Commands

```nu
# Find trailing whitespace in all .nu files
fd '.nu$' | lines | each {|f| open --raw $f | lines | enumerate | where {|l| $l.item =~ '\s+$'} | if ($in | length) > 0 {print $'($f):'; $in | each {|l| print $"  line ($l.index + 1): '($l.item)'"}}}
```

## Examples

### CORRECT

```nu
let x = 42
let y = $x + 1
# No trailing space on this line
```

### INCORRECT

```nu
let x = 42     # ← trailing space before comment
let y = $x + 1 # ← trailing space at end
                # ← line with only spaces
```

## Related Skills

- [nushell-formatting-pipe-spacing](file://.opencode/skills/nushell-formatting-pipe-spacing.md)
- [nushell-formatting-multiline-pipelines](file://.opencode/skills/nushell-formatting-multiline-pipelines.md)
