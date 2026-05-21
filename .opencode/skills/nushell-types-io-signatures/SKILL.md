---
name: nushell-types-io-signatures
description: Description
compatibility: opencode
---

# Nushell Types: I/O Signatures on All Exported Commands

## Description
ALL exported commands MUST declare an I/O signature using the `: input_type -> output_type` syntax immediately after the parameter list.

## When to Load
Load this skill when defining any exported command, reviewing command definitions for completeness, or ensuring type safety across pipeline boundaries.

## Source
STANDARDS.adoc §11.5.4 (lines 4146–4183)

## Key Rules

- MANDATE: Every exported command MUST have an I/O signature after the parameter block and before the function body block.
- MANDATE: Syntax: `]: input_type -> output_type {` where:
  - `]` closes the parameter block
  - `:` separates the parameters from the I/O signature
  - `input_type` is the type the command expects from the pipeline
  - `->` is the arrow operator
  - `output_type` is the type the command outputs to the pipeline
  - `{` opens the function body
- MANDATE: The I/O signature MUST be on the same line as the closing `]` of the parameter block.
- MANDATE: If a command takes no pipeline input, use `nothing` as the input type: `]: nothing -> string`.
- MANDATE: If a command produces no pipeline output, use `nothing` as the output type.
- FORBIDDEN: Omitting the I/O signature on exported commands.
- FORBIDDEN: Using `any -> any` as a lazy escape — specify the actual types.

## Rationale

1. I/O signatures provide compile-time (parse-time) verification of pipeline type flow.
2. They self-document what data shape a command expects and produces, making pipeline composition predictable.
3. Nushell uses I/O signatures for tab completion suggestions, error messages, and pipeline optimization.
4. Commands without I/O signatures degrade Nushell's ability to provide useful diagnostics.
5. Explicit I/O types make refactoring safer — changing a return type produces errors at all call sites.

## Examples

### CORRECT

```nu
# Takes int from pipeline, outputs string
def get-name []: int -> string {
    match $in {
        1 => 'Alice'
        2 => 'Bob'
        _ => 'Unknown'
    }
}

# Takes nothing, outputs record
def get-config []: nothing -> record<host: string, port: int> {
    {host: 'localhost', port: 8080}
}

# Takes string, outputs nothing (side effect only)
def log-msg [msg: string]: string -> nothing {
    print $'[LOG] ($msg)'
}

# Full example: typed params + I/O signature
def process-item [
    id: int
    --verbose (-v)
]: int -> record<id: int, status: string> {
    {id: $id, status: 'ok'}
}
```

### INCORRECT

```nu
def get-name [] {                    # no I/O signature — FORBIDDEN
    42
}

def get-config [] {                  # no I/O signature — FORBIDDEN
    {host: 'localhost', port: 8080}
}

def process-item [id: int] { }       # no I/O signature — FORBIDDEN

def lazy [id: int]: any -> any { }   # any -> any — too permissive — FORBIDDEN
```

## Common I/O Signature Patterns

| Pattern | I/O Signature | Use Case |
|---------|--------------|----------|
| No input, returns string | `]: nothing -> string` | Config readers, generators |
| Takes int, returns record | `]: int -> record<...>` | Lookup commands |
| Pipeline filter | `]: list<int> -> list<string>` | Data transformation |
| Side-effect only | `]: string -> nothing` | Logging, writing files |
| Passthrough | `]: record<...> -> record<...>` | Enrichment/augmentation |

## Related Skills

- [nushell-types-param-annotations](file://.opencode/skills/nushell-types-param-annotations.md)
- [nushell-types-return-type-documented](file://.opencode/skills/nushell-types-return-type-documented.md)
- [nushell-types-complex-syntax](file://.opencode/skills/nushell-types-complex-syntax.md)
