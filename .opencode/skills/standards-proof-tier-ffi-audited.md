# Skill Name: FFI Audited Tier

## Description
`[FFI_AUDITED]` — Unsafe code reviewed by 2 engineers. Every unsafe block MUST be documented with SAFETY comments explaining why it is safe. Used for FFI boundaries, inline assembly, and raw pointer manipulation.

## When to Load
Load this skill when writing or reviewing unsafe code, annotating FFI boundary functions, or documenting SAFETY preconditions for unsafe blocks.

## Source
STANDARDS.adoc §0.3.3 (lines 492–498), §12.2 (lines 4566–4568)

## Key Rules

- MANDATE: `[FFI_AUDITED]` requires unsafe code reviewed by 2 engineers, documented in the annotation
- MANDATE: EVERY unsafe block MUST have a `// SAFETY:` comment explaining why it is safe
- MANDATE: SAFETY comments MUST document: preconditions, invariants, and why they are upheld at the call site
- MANDATE: Every FFI function binding MUST have `#[ffi_audited]` or equivalent marker
- MANDATE: Third-party deps with unsafe code MUST be FFI_AUDITED or `#[forbid(unsafe_code)]`
- FORBIDDEN: Unsafe blocks without SAFETY comments
- FORBIDDEN: Using `[FFI_AUDITED]` for safe code that could be `[PROVED]` or `[TESTED]`

## Example

```rust
/// FFI bridge to the BlazingFastHash C library.
///
/// [FFI_AUDITED] SAFETY reviewed by @alice and @bob on 2024-03-15
/// - Unsafe block #1: pointer dereference (line 127), validated non-null + aligned
/// - Unsafe block #2: FFI call (line 132), function pointer validated at init
/// - No panic paths in safe wrapper before FFI call
pub unsafe fn blazing_fast_hash(input: &[u8]) -> u64 {
    // SAFETY:
    // - `input.as_ptr()` is valid for reads of `input.len()` bytes
    // - Caller guarantees `input` is valid for the lifetime of this call
    // - The FFI function does not retain the pointer after returning
    let ptr = input.as_ptr();
    let len = input.len();

    // SAFETY:
    // - `ffi_hash` is a valid function pointer, checked at init
    // - `ptr` is non-null, aligned, and valid for `len` bytes
    // - The function is documented as thread-safe by the C library
    unsafe { ffi_hash(ptr, len) }
}

/// Registers a callback with the C library.
///
/// [FFI_AUDITED] SAFETY reviewed by @carol on 2024-04-01
/// - Callback is a static function (no captures), safe to call from C
/// - Registration is guarded by a mutex (single-threaded registration)
pub fn register_callback(f: unsafe extern "C" fn(u64)) {
    // SAFETY:
    // - `f` is a static function with C ABI, safe to pass to C code
    // - The C library only calls `f` from the event loop thread
    // - Registration happens before the event loop starts
    unsafe { ffi_register_callback(f) };
}
```

```rust
/// Fast memory copy using SIMD.
///
/// [FFI_AUDITED]
/// Missing reviewer names — FORBIDDEN
pub unsafe fn fast_copy(dst: *mut u8, src: *const u8, len: usize) {
    // Missing SAFETY comment — FORBIDDEN
    unsafe { std::ptr::copy_nonoverlapping(src, dst, len) };
}
```

```rust
// INCORRECT — unsafe without audit
/// Wraps a raw file descriptor.
///
/// [LINTED]  // INCORRECT: contains unsafe code, must be [FFI_AUDITED]
pub struct RawFd(i32);
impl RawFd {
    pub unsafe fn new(fd: i32) -> Self { Self(fd) }
    // No SAFETY comment on unsafe fn — FORBIDDEN
}
```

## Related Skills
- [standards-proof-tier-annotations](file://.opencode/skills/standards-proof-tier-annotations.md)
- [standards-suckless-inline-over-deps](file://.opencode/skills/standards-suckless-inline-over-deps.md)
