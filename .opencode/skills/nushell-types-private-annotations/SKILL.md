---
name: nushell-types-private-annotations
description: Description
compatibility: opencode
---

# Nushell Types: Private Commands SHOULD Have Type Annotations

## Description
Private commands (declared with `def --private` or `def` inside a module but not exported) SHOULD have type annotations on parameters and SHOULD have I/O signatures.

## When to Load
Load this skill when writing internal/private/helper commands within modules, or when deciding whether to add types to non-exported commands.

## Source
STANDARDS.adoc §11.5.4 (lines 4146–4183)

## Key Rules

- SHOULD: Private commands SHOULD have type annotations on all parameters (same as exported commands).
- SHOULD: Private commands SHOULD declare I/O signatures.
- FORBIDDEN: Using the "it's private" excuse to skip types on complex commands with multiple parameters.
- FORBIDDEN: Routinely omitting types from private commands — the expectation is that you SHOULD add them.

## Rationale

1. Type annotations catch parse-time errors regardless of visibility — a private command with untyped parameters can still fail at runtime with confusing errors.
2. Private commands often become public during refactoring; having types already present prevents a separate typing pass.
3. Consistently typed code is easier to reason about — distinguishing "typed private" from "untyped private" adds mental overhead.
4. I/O signatures on private commands help the Nushell parser verify internal pipeline correctness.
5. The SHOULD (rather than MUST) exists only to allow rapid prototyping, not as a permanent exemption.

## Examples

### CORRECT (preferred)

```nu
# Private helper — fully typed
def --private parse-row [
    raw: string
    delimiter: string = ','
]: string -> record<fields: list<string>, count: int> {
    let fields = $raw | split row $delimiter
    {fields: $fields, count: ($fields | length)}
}

# Private helper — typed parameters, no I/O signature (acceptable but not preferred)
def --private format-name [
    first: string
    last: string
] {
    $'($first) ($last)'
}
```

### ACCEPTABLE (rapid prototyping only)

```nu
# Acceptable during initial development ONLY
def --private helper [input] {
    $input | str upcase
}
```

### INCORRECT (avoid even for private commands)

```nu
# Multiple params, all untyped — confusing and error-prone
def --private process [data, config, options] {
    # What types are these? Reader has to trace call sites.
}
```

## When To Skip Types (Rare)

- One-liner private commands with trivial, obvious parameters
- Commands in the process of being refactored (types to be added in same PR)
- Exploratory/prototype code that will be discarded

Even in these cases, add types before committing.

## Related Skills

- [nushell-types-param-annotations](file://.opencode/skills/nushell-types-param-annotations.md)
- [nushell-types-io-signatures](file://.opencode/skills/nushell-types-io-signatures.md)
