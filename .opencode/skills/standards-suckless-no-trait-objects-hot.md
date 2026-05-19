# Skill Name: No Trait Objects in Hot Paths

## Description
Trait objects (`dyn Trait`) SHOULD be avoided in performance-sensitive paths because dynamic dispatch prevents Kani proof and hurts cache locality. Enums SHOULD be preferred for fixed-variant polymorphism.

## When to Load
Load this skill when designing polymorphic APIs, reviewing code that uses `dyn Trait`, or optimizing hot paths with dispatch overhead.

## Source
STANDARDS.adoc §0.1.3 (lines 117–119)

## Key Rules

- SHOULD: Avoid trait objects (`dyn Trait`) in performance-sensitive paths
- SHOULD: Prefer enums over trait objects for fixed-variant polymorphism
- MANDATE: Trait objects are FORBIDDEN in Kani-proved code (dynamic dispatch prevents proof)
- MANDATE: Hot loops MUST NOT use dynamic dispatch
- SHOULD: Use `impl Trait` (static dispatch) where the concrete type is known
- SHOULD: Use enums with match arms for finite sets of variants

## Example

```rust
// CORRECT — Enum-based polymorphism (static dispatch, Kani-provable)
pub enum OutputStream {
    File(File),
    Tcp(TcpStream),
    Buffer(Vec<u8>),
}

impl Write for OutputStream {
    fn write(&mut self, buf: &[u8]) -> io::Result<usize> {
        match self {
            OutputStream::File(f) => f.write(buf),
            OutputStream::Tcp(s) => s.write(buf),
            OutputStream::Buffer(b) => b.write(buf),
        }
    }
}
```

```rust
// INCORRECT — Trait object in hot path
pub fn process_all(items: &[Item], out: &mut dyn Write) -> io::Result<()> {
    // FORBIDDEN in hot paths: dyn Write prevents inlining,
    // causes indirect call overhead, and blocks Kani proof
    for item in items {
        out.write(&item.serialize())?;
    }
    Ok(())
}
```

```rust
// CORRECT — Static dispatch with generics
pub fn process_all(items: &[Item], out: &mut impl Write) -> io::Result<()> {
    // Static dispatch — monomorphized, inlinable, Kani-provable
    for item in items {
        out.write(&item.serialize())?;
    }
    Ok(())
}
```

```rust
// CORRECT — Conditional trait objects OK in cold path
// Main function (top-level orchestration) — appropriate for dyn
pub fn main() -> io::Result<()> {
    let out: Box<dyn Write> = if args.stdout {
        Box::new(io::stdout())
    } else {
        Box::new(File::create(&args.output)?)
    };
    // This is fine: main() is cold, called once per invocation
    process_all(&items, &mut *out)
}
```

## Related Skills
- [standards-suckless-inline-over-deps](file://.opencode/skills/standards-suckless-inline-over-deps.md)
- [standards-proof-coding-for-kani](file://.opencode/skills/standards-proof-coding-for-kani.md)
