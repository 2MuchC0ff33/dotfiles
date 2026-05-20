# Skill: asciidoc-callouts-vs-inline-comments

## Description

Use AsciiDoc callouts for code explanation. Inline comments in code blocks are FORBIDDEN.

## When to Load

Load this skill when annotating or explaining code examples, configuration snippets, or command output in `.adoc` files.

## Source

STANDARDS.adoc §9.6 (line 3298)

## Key Rules

- MANDATE: Callouts for explanation, NOT inline comments in code blocks.
- MANDATE: Use `// <N>` comment markers within code blocks to mark callout points.
- MANDATE: Provide the callout explanation as a numbered list after the code block, using `<N>.` syntax.
- FORBIDDEN: Explanatory comments inside code blocks that duplicate callout functionality.
- SHOULD: Keep callout explanations concise — one or two sentences per callout.

## Example

### CORRECT — callouts for explanation

```asciidoc
[source,rust]
----
use std::fs;        // <1>
use std::io;        // <2>

fn main() -> io::Result<()> {
    let data = fs::read_to_string("config.toml")?;  // <3>
    println!("{}", data);
    Ok(())
}
----

<1> Import the filesystem module for file operations.
<2> Import the I/O module for error types.
<3> Read the entire configuration file into a string. The `?` operator propagates any I/O error.
```

### INCORRECT — inline comments instead of callouts

```asciidoc
[source,rust]
----
// Import the filesystem module for file operations
use std::fs;
// Import the I/O module for error types
use std::io;

fn main() -> io::Result<()> {
    // Read the entire configuration file into a string
    let data = fs::read_to_string("config.toml")?;
    println!("{}", data);
    Ok(())
}
----
// Inline comments clutter the code and cannot be translated/restructured separately
```

### INCORRECT — callout marker without explanation

```asciidoc
[source,rust]
----
use std::fs;        // <1>
----
// Missing callout list — <1> is never explained
```

## Rationale

Callouts separate the explanation from the code, keeping code listings
clean and copy-paste friendly. Unlike inline comments, callouts can be
translated independently, restructured, and styled differently in the
rendered output. Inline comments in code blocks also risk being mistaken
for actual code comments, and they cannot be selectively shown/hidden in
different output formats (HTML tooltips, PDF margin notes, etc.).

## Related Skills

- [asciidoc-code-blocks-language](file://.opencode/skills/asciidoc-code-blocks-language.md)
- [asciidoc-admonitions-with-titles](file://.opencode/skills/asciidoc-admonitions-with-titles.md)
