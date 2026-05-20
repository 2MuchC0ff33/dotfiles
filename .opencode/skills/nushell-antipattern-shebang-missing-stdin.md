# Anti-Pattern #16: Missing Stdin in Shebang

## Description
Anti-pattern: Missing `--stdin` in shebang. Use `#!/usr/bin/env -S nu --stdin`.

## When to Load
Load this skill when creating `.nu` scripts intended for direct execution.

## Source
STANDARDS.adoc §11.5.9 (lines 4420–4440)

## Key Rules

- FORBIDDEN: Missing `--stdin` in shebang
- MANDATE: Use `#!/usr/bin/env -S nu --stdin`

## Rationale

Without `--stdin`, Nushell scripts executed as standalone executables may not properly receive pipeline input via `$in`. The `-S` flag to `env` passes the entire argument as a single shebang directive.

## Example

```nu
# BAD — missing --stdin (anti-pattern #16)
#!/usr/bin/env nu

# GOOD — --stdin in shebang
#!/usr/bin/env -S nu --stdin

# BAD — incorrect shebang (--stdin missing but script expects $in)
#!/usr/bin/env nu
let data = $in         # may not receive input!
$data | each {|line| ... }

# GOOD — correct shebang
#!/usr/bin/env -S nu --stdin
let data = $in
$data | each {|line| ... }

# GOOD — script with --stdin and pipeline processing
#!/usr/bin/env -S nu --stdin
# Count lines in pipeline input
$in | length
```
