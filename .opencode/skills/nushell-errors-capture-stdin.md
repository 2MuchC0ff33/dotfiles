# Capture Stdin With Let

## Description
Capture `$in` with `let` when it is used multiple times to avoid consuming the pipeline input.

## When to Load
Load this skill when processing pipeline input (`$in`) that needs to be referenced more than once.

## Source
STANDARDS.adoc §11.5.7 (lines 4255–4266)

## Key Rules

- SHOULD: Capture `$in` with `let` when used multiple times (streaming caveat)
- MANDATE: Fallible operations MUST be wrapped in `try`/`catch`

## Rationale

In Nushell, `$in` is consumed on first use. Referencing `$in` twice in a command will fail on the second access because the pipeline input has already been consumed. Always bind `$in` to a `let` variable if you need to use it more than once.

## Example

```nu
# BAD — $in used twice, second access fails
def process [] {
    let count = ($in | length)
    let total = ($in | math sum)     # Error! $in already consumed!
    {count: $count, total: $total}
}

# GOOD — capture $in once
def process [] {
    let data = $in
    let count = ($data | length)
    let total = ($data | math sum)
    {count: $count, total: $total}
}

# BAD — $in used multiple times inline
ls
| where $in.size > 1mb              # OK
| each { if $in.name =~ '\.log$' { $in.name } }  # $in is now file, not ls!

# GOOD — capture for multiple uses
def filter-large [] {
    let files = $in
    let large = ($files | where size > 1mb)
    let names = ($files | where size > 1mb | get name)
    {large_count: ($large | length), names: $names}
}

# Streaming caveat: for very large data, collect only what you need
let data = ($in | take 1000)        # limit if streaming
let count = ($data | length)
let sample = ($data | first 10)
```

## Related Skills
- nushell-errors-try-catch
- nushell-pipeline-pipelines-over-imperative
- nushell-antipattern-pipeline-vs-params
