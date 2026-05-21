---
name: standards-error-invariant-violation
description: Description
compatibility: opencode
---

# Skill Name: Invariant Violation Protocol

## Description
`InvariantViolation` is a structured error type for unrecoverable bugs. Invariant violations SHALL be logged at ERROR level and terminate the operation. They indicate a bug, not a recoverable error.

## When to Load
Load this skill when defining invariant violation types, adding runtime invariant checks, or distinguishing between recoverable errors and unrecoverable bugs.

## Source
STANDARDS.adoc §3.3 (lines 4571–4600)

## Key Rules

- MANDATE: Invariant violations SHALL be logged at ERROR level
- MANDATE: Invariant violations SHALL terminate the operation (not recoverable)
- MANDATE: `InvariantViolation` MUST include file and line number for debugging
- MANDATE: `InvariantViolation` indicates a BUG, not a recoverable error
- SHOULD: Use a macro to automatically capture `file!()` and `line!()` at the violation site
- SHOULD: Panic or abort after logging (since it indicates a bug)
- FORBIDDEN: Using `InvariantViolation` for recoverable errors (use structured error types)
- FORBIDDEN: Catching or recovering from invariant violations

## Example

```rust
// CORRECT — InvariantViolation definition and usage
use std::error::Error;
use std::fmt;

/// An invariant violation — indicates a BUG, not a recoverable error.
///
/// [PROVED] Kani proves this is never constructed when invariants hold.
#[derive(Debug)]
pub struct InvariantViolation {
    pub message: &'static str,
    pub file: &'static str,
    pub line: u32,
}

impl Error for InvariantViolation {}

impl fmt::Display for InvariantViolation {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(f, "Invariant violation: {} at {}:{}",
            self.message, self.file, self.line)
    }
}

/// Macro to raise an invariant violation with automatic source location.
#[macro_export]
macro_rules! invariant_violation {
    ($msg:expr) => {{
        let violation = InvariantViolation {
            message: $msg,
            file: file!(),
            line: line!(),
        };
        log::error!("{}", violation);  // MUST log at ERROR
        panic!("{}", violation);       // MUST terminate operation
    }};
}

// Usage — when a critical invariant is detected:
pub fn process_entity(entity: &Entity, world: &World) {
    let health = entity.health;
    if health.current > health.maximum {
        // BUG: invariant violated — current should never exceed maximum
        invariant_violation!("Entity health.current ({}) exceeds health.maximum ({})",
            health.current, health.maximum);
        // Unreachable: invariant_violation! panics
    }
    // ... continue processing, invariant holds
}
```

```rust
// INCORRECT — Using InvariantViolation for recoverable errors
pub fn validate_user_input(input: &str) -> Result<(), InvariantViolation> {
    // FORBIDDEN: user input validation is a recoverable error, not a bug
    if input.is_empty() {
        invariant_violation!("empty input");  // Wrong! This is a user error, not a bug
    }
    Ok(())
}
// Correct approach: return a structured error type like ValidationError
```

```rust
// INCORRECT — Catching or recovering
use std::panic::catch_unwind;

let result = catch_unwind(|| {
    process_entity(&bad_entity, &world);
});
// FORBIDDEN: Invariant violations MUST terminate the operation
// Catching them undermines the bug-detection purpose
```

## Related Skills
- [standards-error-struct-variants](file://.opencode/skills/standards-error-struct-variants.md)
- [standards-error-source-location](file://.opencode/skills/standards-error-source-location.md)
- [standards-error-no-anyhow-lib](file://.opencode/skills/standards-error-no-anyhow-lib.md)
