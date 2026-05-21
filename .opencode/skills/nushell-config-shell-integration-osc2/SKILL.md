---
name: nushell-config-shell-integration-osc2
description: Description
compatibility: opencode
---

# nushell-config-shell-integration-osc2

## Description
Enable OSC 2 shell integration sequences to set the terminal window title automatically.

## When to Load
Load this skill when configuring `$env.config.shell_integration.osc2` in `config.nu`.

## Source
STANDARDS.adoc §11.1 (line 3657)

## Key Rules

- MANDATE: `$env.config.shell_integration.osc2` MUST be `true`.
- SHOULD: OSC 2 is the mechanism that sets the terminal window title to the currently running command, providing visual context.
- FORBIDDEN: Setting `osc2 = false` or omitting it from the `shell_integration` block.

## Rationale

OSC 2 (Operating System Command 2) tells the terminal emulator to update its
window title to reflect the command currently being executed. When you run
`cargo build`, your terminal tab shows "cargo build" instead of a static
label. This is essential for terminal multiplexers, tabbed terminals, and
window managers that display window titles.

## Example

```nushell
$env.config = {
    shell_integration: {
        osc2:   true
        osc7:   true
        osc133: true
    }
}
```

## Related Skills
- [nushell-config-shell-integration-osc7](file://.opencode/skills/nushell-config-shell-integration-osc7.md)
- [nushell-config-shell-integration-osc133](file://.opencode/skills/nushell-config-shell-integration-osc133.md)
