# Skill Name: Maximum Function Size

## Description
No function exceeds 40 lines (one terminal screen). Functions longer than 40 lines MUST be refactored into smaller helper functions.

## When to Load
Load this skill when writing new functions, reviewing PRs for function length compliance, or refactoring overly long functions.

## Source
STANDARDS.adoc §0.1.3 (line 105)

## Key Rules

- MANDATE: No function exceeds 40 lines (including signature, excluding doc comments)
- MANDATE: A function exceeding 40 lines MUST be broken into smaller, single-purpose functions
- SHOULD: Target 10-25 lines per function for most logic
- FORBIDDEN: 100+ line functions that mix multiple responsibilities
- FORBIDDEN: Functions where the body scrolls beyond one terminal screen (typically 40 lines)

## Example

```rust
// CORRECT — Function under 40 lines, single purpose
/// Validates a hostname string against RFC 1123.
pub fn validate_hostname(hostname: &str) -> Result<(), ValidationError> {
    if hostname.is_empty() {
        return Err(ValidationError::Empty);
    }
    if hostname.len() > 253 {
        return Err(ValidationError::TooLong);
    }
    for segment in hostname.split('.') {
        if segment.is_empty() {
            return Err(ValidationError::EmptySegment);
        }
        if segment.len() > 63 {
            return Err(ValidationError::SegmentTooLong);
        }
        if !segment.as_bytes()[0].is_ascii_alphanumeric() {
            return Err(ValidationError::InvalidStart);
        }
    }
    Ok(())
} // 18 lines — well under limit
```

```rust
// INCORRECT — Function exceeds 40 lines
pub fn process_transaction(tx: &Transaction) -> Result<(), Error> {
    // Validate sender
    if tx.sender.is_empty() { return Err(Error::EmptySender); }
    if tx.sender.len() > 42 { return Err(Error::SenderTooLong); }
    // ...5 lines

    // Validate recipient
    if tx.recipient.is_empty() { return Err(Error::EmptyRecipient); }
    if tx.recipient.len() > 42 { return Err(Error::RecipientTooLong); }
    // ...5 lines

    // Verify signature
    let hash = sha256(&tx.encoded_payload());
    // ...8 lines of crypto code

    // Check nonce
    let current_nonce = get_nonce(&tx.sender)?;
    if tx.nonce <= current_nonce { return Err(Error::StaleNonce); }
    // ...4 lines

    // Apply state changes
    update_balance(tx.sender, -tx.amount)?;
    update_balance(tx.recipient, tx.amount)?;
    // ...8 lines of event emission and logging

    // This function is now 48 lines — VIOLATION
    // Refactor into: validate_transaction(), verify_signature(), apply_transaction()
    Ok(())
}
```

## Related Skills
- [standards-suckless-max-file-size](file://.opencode/skills/standards-suckless-max-file-size.md)
- [standards-suckless-one-purpose](file://.opencode/skills/standards-suckless-one-purpose.md)
