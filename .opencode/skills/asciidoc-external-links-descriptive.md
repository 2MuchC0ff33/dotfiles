# Skill: asciidoc-external-links-descriptive

## Description

ALL external links MUST have descriptive text. Bare URLs and "Click here" as link text are FORBIDDEN.

## When to Load

Load this skill when adding external hyperlinks (URLs to external sites) in any `.adoc` file.

## Source

STANDARDS.adoc §9.6 (lines 3261 and 3264)

## Key Rules

- MANDATE: ALL external links MUST have descriptive link text.
- MANDATE: Use `url[Link Text]` or `url[Link Text, window=_blank]` syntax.
- FORBIDDEN: Bare URLs as link text.
- FORBIDDEN: "Click here" as link text.
- FORBIDDEN: "Read more", "Learn more", "This page" — anything non-descriptive.
- SHOULD: Link text should describe the destination or the content being linked to.

## Example

### CORRECT — descriptive link text

```asciidoc
Refer to the Rust installation page for setup instructions.
https://www.rust-lang.org/tools/install[Install Rust]

See the PostgreSQL documentation for connection string syntax.
https://www.postgresql.org/docs/current/libpq-connect.html#LIBPQ-CONNSTRING[PostgreSQL Connection Strings]
```

### CORRECT — with window target

```asciidoc
https://github.com/2MuchC0ff33/dotfiles[Project Repository, window=_blank]
```

### INCORRECT — bare URL

```asciidoc
Refer to https://www.rust-lang.org/tools/install for setup instructions.
// Bare URL — no descriptive text, hard to scan
```

### INCORRECT — "Click here"

```asciidoc
For setup instructions, click here:
https://www.rust-lang.org/tools/install[Click here]
// "Click here" does not describe the destination
```

### INCORRECT — generic text

```asciidoc
Read more at https://www.postgresql.org/docs/current/libpq-connect.html[this page].
// "this page" provides no context about the content
```

## Rationale

Descriptive link text improves accessibility (screen readers list links out
of context), scannability (readers find relevant destinations quickly), and
SEO. Bare URLs and generic text like "Click here" force readers to follow
the link or read surrounding context to understand the destination, which is
especially problematic in printed documentation.

## Related Skills

- [asciidoc-cross-references-explicit](file://.opencode/skills/asciidoc-cross-references-explicit.md)
- [asciidoc-forbidden-language](file://.opencode/skills/asciidoc-forbidden-language.md)
