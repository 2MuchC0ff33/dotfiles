# Nushell Formatting: No Commas in List Literals

## Description
Commas MUST be omitted between items in list literals. Use whitespace-separated values instead.

## When to Load
Load this skill when writing list literals (`[1 2 3]`), reviewing array definitions, or creating table literals (`[[col1 col2]; [val1 val2]]`).

## Source
STANDARDS.adoc §11.5.2 (lines 4061–4123)

## Key Rules

- MANDATE: List items MUST be separated by whitespace, not commas: `[1 2 3]`, `[foo bar baz]`.
- MANDATE: Table literal rows MUST use space-separated values: `[[name age]; [Alice 30] [Bob 25]]`.
- FORBIDDEN: Commas between list items: `[1, 2, 3]`, `[foo, bar, baz]`.
- FORBIDDEN: Commas in table literal rows: `[[name age]; [Alice, 30], [Bob, 25]]`.
- FORBIDDEN: Trailing commas in list literals: `[1, 2, 3,]`.
- ACCEPTABLE: Commas in Record literals after key-value pairs: `{x: 1, y: 2}` (see `nushell-formatting-record-colons`).

## Rationale

1. Nushell's parser treats whitespace as the list separator natively — commas are redundant and non-standard.
2. Removing commas reduces visual noise and aligns with Nushell's philosophy of minimal syntax.
3. Commas in lists are a legacy convention from languages like JavaScript/Python; Nushell intentionally diverges for cleaner syntax.
4. Whitespace-separated lists are more flexible for multi-line formatting and align with the language's design.

## Examples

### CORRECT

```nu
[1 2 3 4]
[foo bar baz]
[apple banana cherry]
[[name age]; [Alice 30] [Bob 25]]
[[status count]; [UP 10] [DOWN 2]]
$data | where $it in [red green blue]
```

### INCORRECT

```nu
[1, 2, 3, 4]                              # commas — FORBIDDEN
[foo, bar, baz]                            # commas — FORBIDDEN
[apple, banana, cherry]                    # commas — FORBIDDEN
[[name age]; [Alice, 30], [Bob, 25]]       # commas in rows — FORBIDDEN
[[status count]; [UP, 10], [DOWN, 2]]      # commas — FORBIDDEN
$data | where $it in [red, green, blue]    # commas — FORBIDDEN
[1, 2, 3,]                                 # trailing comma — FORBIDDEN
```

## Interaction With Other Rules

- In record literals, commas ARE used between key-value pairs: `{x: 1, y: 2}`.
- In multi-line list formatting, each item goes on its own line with no commas.

## Related Skills

- [nushell-formatting-record-colons](file://.opencode/skills/nushell-formatting-record-colons.md)
- [nushell-formatting-multiline-pipelines](file://.opencode/skills/nushell-formatting-multiline-pipelines.md)
