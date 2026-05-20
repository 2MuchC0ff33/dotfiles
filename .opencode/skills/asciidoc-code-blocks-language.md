# Skill: asciidoc-code-blocks-language

## Description

ALL code blocks MUST declare their language. Input and output MUST be in SEPARATE blocks.

## When to Load

Load this skill when writing code examples, command-line sessions, or input/output demonstrations in `.adoc` files.

## Source

STANDARDS.adoc §9.6 (lines 3296–3297)

## Key Rules

- MANDATE: ALL code blocks MUST declare their language.
- MANDATE: Input and output MUST be in SEPARATE blocks.
- MANDATE: Use the `[source,<language>]` attribute before fenced or delimited code blocks.
- SHOULD: Use `[source,console]` for shell sessions (input only).
- SHOULD: Use `[source,output]` or `[source,text]` for command output.
- FORBIDDEN: Bare `----` or triple-backtick blocks without a language declaration.

## Example

### CORRECT — separate input and output blocks

```asciidoc
List files in the current directory:

[source,console]
----
ls -la
----

[source,text]
----
total 24
drwxr-xr-x  2 user user 4096 Mar 15 10:00 .
drwxr-xr-x 10 user user 4096 Mar 15 10:00 ..
-rw-r--r--  1 user user  147 Mar 15 10:00 main.rs
----
```

### CORRECT — programming language blocks

```asciidoc
[source,rust]
----
fn main() {
    println!("Hello, world!");
}
----
```

### INCORRECT — mixed input and output in one block

```asciidoc
[source,console]
----
$ ls -la
total 24
drwxr-xr-x  2 user user 4096 Mar 15 10:00 .
$ echo "hello"
hello
----
// Output mixed with command prompts makes it impossible to copy-paste
```

### INCORRECT — missing language declaration

```asciidoc
----
fn main() {
    println!("Hello, world!");
}
----
// No language declaration — no syntax highlighting, no linting
```

### INCORRECT — bare triple backticks

````asciidoc
```
fn main() {
    println!("Hello, world!");
}
```
````

## Rationale

Declaring the language enables syntax highlighting in the rendered output
and structural linting in CI. Separating input from output ensures readers
can copy-paste commands without capturing prompts or result text, which is
critical for a good developer experience.

## Related Skills

- [asciidoc-callouts-vs-inline-comments](file://.opencode/skills/asciidoc-callouts-vs-inline-comments.md)
- [asciidoc-one-sentence-per-line](file://.opencode/skills/asciidoc-one-sentence-per-line.md)
