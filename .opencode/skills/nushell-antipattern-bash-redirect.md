# Anti-Pattern #5: Bash-Style Redirection

## Description
Anti-pattern: Bash-style redirection (`>`). Use `save` / `save --append`.

## When to Load
Load this skill when writing output to files.

## Source
STANDARDS.adoc §11.5.9 (lines 4362–4371)

## Key Rules

- FORBIDDEN: Bash-style redirection (`>`)
- MANDATE: Use `save` / `save --append`

## Rationale

Nushell does not support `>` redirection like bash. The `save` command is the idiomatic way to write pipeline output to files. It supports append mode with `--append` and accepts pipeline input naturally.

## Example

```nu
# BAD — bash-style redirection (anti-pattern #5)
ls > files.txt                      # Error! Not valid in Nushell
echo 'hello' > greeting.txt         # Error!

# BAD — trying to use > in Nushell
ps | where cpu > 10 > processes.txt # Syntax error

# GOOD — save
ls | save files.txt

# GOOD — save append
ls | save --append files.txt

# GOOD — save with pipeline
'hello' | save greeting.txt

# GOOD — save in a script
let data = (ls)
$data | save report.txt

# GOOD — save with stderr capture
let result = (^cargo build o+e>| complete)
if $result.exit_code != 0 {
    $result.stderr | save build_errors.log
}
```

## Related Skills
- nushell-antipattern-string-parse-external
- nushell-security-temp-files
- nushell-performance-streaming
