# Skill Name: No cfg Scatter

## Description
Conditional compilation (`#[cfg]`) for platform-specific code is FORBIDDEN without a clear module boundary. Use separate files with `#[cfg]` at the module level, not `#[cfg]` gates scattered through shared code.

## When to Load
Load this skill when writing platform-specific code, reviewing PRs that use `#[cfg]`, or refactoring scattered conditional compilation.

## Source
STANDARDS.adoc §0.1.3 (lines 112–114)

## Key Rules

- FORBIDDEN: `#[cfg]` for platform-specific code without a clear module boundary
- MANDATE: Platform-specific code lives in separate files, conditionally compiled at the module level via `mod` with `#[cfg]`
- MANDATE: Shared code MUST NOT contain inline `#[cfg]` for platform differences
- SHOULD: Use `cfg_select!` macro (from cfg-if) over inline `#[cfg]` for compile-time branching in shared code
- FORBIDDEN: `#[cfg(windows)]`, `#[cfg(unix)]`, etc. scattered throughout implementation files
- FORBIDDEN: More than one OS-conditional block per file

## Example

```rust
// CORRECT — Platform abstraction via module boundary
// src/platform/mod.rs
#[cfg(unix)]
mod linux;
#[cfg(windows)]
mod windows;
#[cfg(target_os = "macos")]
mod macos;

pub use self::linux::*;
pub use self::windows::*;
pub use self::macos::*;

// src/platform/linux.rs
pub fn get_memory_info() -> MemoryInfo {
    // Linux-specific implementation using /proc/meminfo
}

// src/platform/windows.rs
pub fn get_memory_info() -> MemoryInfo {
    // Windows-specific implementation using GlobalMemoryStatusEx
}

// Usage in shared code — no cfg gates!
use crate::platform::get_memory_info;
let mem = get_memory_info();
```

```rust
// INCORRECT — cfg gates scattered through shared code
// src/memory.rs

pub struct MemoryInfo {
    pub total: u64,
    pub used: u64,
    pub free: u64,
}

pub fn get_memory_info() -> MemoryInfo {
    #[cfg(unix)] {
        // Linux implementation reading /proc/meminfo
        let total = read_from_proc("MemTotal");
        let free = read_from_proc("MemFree");
        MemoryInfo { total, used: total - free, free }
    }
    #[cfg(windows)] {
        // Windows implementation
        let mut info = std::mem::zeroed();
        unsafe { windows::GlobalMemoryStatusEx(&mut info); }
        MemoryInfo {
            total: info.ullTotalPhys,
            used: info.ullTotalPhys - info.ullAvailPhys,
            free: info.ullAvailPhys,
        }
    }
    // FORBIDDEN: Multiple #[cfg] blocks in same function
    // Should be split into separate platform modules
}
```

```rust
// INCORRECT — Inline cfg on individual fields
pub struct PlatformState {
    pub common_field: u32,
    #[cfg(unix)]
    pub fd: RawFd,           // FORBIDDEN: cfg on individual fields
    #[cfg(windows)]
    pub handle: HANDLE,      // FORBIDDEN: cfg on individual fields
}
// Use separate platform-specific structs instead
```

## Related Skills
- [standards-suckless-one-purpose](file://.opencode/skills/standards-suckless-one-purpose.md)
- [standards-suckless-inline-over-deps](file://.opencode/skills/standards-suckless-inline-over-deps.md)
