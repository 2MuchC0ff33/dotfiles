# Skill Name: Tested Tier

## Description
`[TESTED]` — Property-based testing (proptest) with 10,000+ random cases per property. Used for functions Kani cannot handle: FFI, syscalls, unbounded algorithms, external services. Covers algebraic properties, round-trips, and idempotence.

## When to Load
Load this skill when annotating functions with `[TESTED]`, writing proptest harnesses, or deciding when to use property-based testing over Kani proofs.

## Source
STANDARDS.adoc §0.3.3 (lines 483–490), §12.2 (lines 4558–4560)

## Key Rules

- MANDATE: `[TESTED]` requires a proptest with 10,000+ random cases per property in CI
- MANDATE: Use for functions Kani cannot handle (FFI, syscalls, unbounded algorithms, external services)
- MANDATE: Every property tested MUST be documented in the annotation
- SHOULD: Cover algebraic properties (commutativity, associativity, idempotence), round-trips (serialize → parse), and invariants
- SHOULD: Place proptest files in `tests/proptest/`
- FORBIDDEN: Using `[TESTED]` on code that could be `[PROVED]` (core logic, parsing, state machines)

## Example

```rust
/// Sends a packet over the network.
///
/// [TESTED] proptest in tests/proptest/network.rs
/// - Properties: send + receive roundtrip, ordering preserved
/// - Coverage: 10_000 random payload sizes and distributions
/// Note: Kani cannot prove syscall behavior. We prove up to the syscall boundary.
pub fn send_packet(conn: &mut Connection, payload: &[u8]) -> io::Result<()> {
    conn.socket.write_all(payload)?;
    Ok(())
}

// Corresponding proptest (tests/proptest/network.rs):
proptest! {
    #[test]
    fn send_recv_roundtrip(payload: Vec<u8>) {
        // Create connected pair
        let (mut a, mut b) = create_loopback()?;
        send_packet(&mut a, &payload)?;
        let received = receive_packet(&mut b)?;
        prop_assert_eq!(payload, received);
    }

    #[test]
    fn ordering_preserved(messages: Vec<Vec<u8>>) {
        let (mut a, mut b) = create_loopback()?;
        for msg in &messages {
            send_packet(&mut a, msg)?;
        }
        for expected in &messages {
            let received = receive_packet(&mut b)?;
            prop_assert_eq!(*expected, received);
        }
    }
}
```

```rust
/// Parses a configuration from DER bytes.
///
/// [TESTED]  // INCORRECT: parsing is core logic — should be [PROVED] with Kani
pub fn parse_config(bytes: &[u8]) -> Result<Config, Error> {
    // Parser that Kani could fully model-check
}
```

## Related Skills
- [standards-proof-tier-annotations](file://.opencode/skills/standards-proof-tier-annotations.md)
- [standards-proof-proptest-mandates](file://.opencode/skills/standards-proof-proptest-mandates.md)
