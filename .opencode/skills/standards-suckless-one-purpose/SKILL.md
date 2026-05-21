---
name: standards-suckless-one-purpose
description: Description
compatibility: opencode
---

# Skill Name: One Purpose Per Function

## Description
Every function does exactly one thing. If a function's name contains "and", it is doing too many things and MUST be split.

## When to Load
Load this skill when writing new functions, reviewing PRs for single-responsibility violations, or refactoring functions that have grown to do multiple things.

## Source
STANDARDS.adoc §0.1.3 (lines 103–104)

## Key Rules

- MANDATE: One purpose per function
- MANDATE: If a function has "and" in its name, it does too many things — split it
- MANDATE: A function name MUST accurately describe the single thing it does
- SHOULD: Pure functions (data-in, data-out, no side effects) are preferred
- FORBIDDEN: Functions named `do_foo_and_bar` — split into `do_foo` and `do_bar`
- FORBIDDEN: Functions with "and" in the name (e.g., `parse_and_validate`, `load_and_process`)

## Example

```rust
// CORRECT — Single-purpose functions
/// Parses a DER-encoded certificate.
pub fn parse_certificate(bytes: &[u8]) -> Result<Certificate, ParseError> { /* ... */ }

/// Validates certificate constraints (expiry, key usage, etc.).
pub fn validate_certificate(cert: &Certificate) -> Result<(), ValidationError> { /* ... */ }

/// Stores a validated certificate in the trust store.
pub fn store_certificate(cert: &Certificate) -> Result<(), StoreError> { /* ... */ }
```

```rust
// INCORRECT — Function with "and" in name
/// Parses and validates a certificate.
pub fn parse_and_validate_certificate(bytes: &[u8]) -> Result<Certificate, Error> {
    // This function does TWO things: parse AND validate
    // If parse succeeds but validation fails, caller can't distinguish
    // Split into parse_certificate() + validate_certificate()
    let cert = Certificate::from_der(bytes).map_err(|e| Error::Parse(e))?;
    cert.validate_expiry()?;
    cert.validate_key_usage()?;
    Ok(cert)
}
```

```rust
// INCORRECT — Function does multiple things despite clean name
pub fn process_order(order: &Order) -> Result<(), Error> {
    // 1. Validates the order
    // 2. Charges the customer
    // 3. Sends confirmation email
    // 4. Updates inventory
    // Split into: validate_order, charge_customer, send_confirmation, update_inventory
    order.validate()?;
    charge(order.customer, order.total)?;
    email::send_confirmation(&order.customer.email, &order)?;
    inventory::deduct(order.items.iter())?;
    Ok(())
}
```

## Related Skills
- [standards-suckless-max-function-size](file://.opencode/skills/standards-suckless-max-function-size.md)
- [standards-suckless-max-file-size](file://.opencode/skills/standards-suckless-max-file-size.md)
