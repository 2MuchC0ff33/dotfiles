---
name: nushell-config-shell-integration-osc7
description: Description
compatibility: opencode
---

# nushell-config-shell-integration-osc7

## Description
Enable OSC 7 shell integration sequences to advertise the current working directory as a file URI to the terminal emulator.

## When to Load
Load this skill when configuring `$env.config.shell_integration.osc7` in `config.nu`.

## Source
STANDARDS.adoc §11.1 (line 3658)

## Key Rules

- MANDATE: `$env.config.shell_integration.osc7` MUST be `true`.
- SHOULD: OSC 7 reports the working directory URL (`file://hostname/path`) so terminals and multiplexers can track location per-pane.
- FORBIDDEN: Setting `osc7 = false` or omitting this key.

## Rationale

OSC 7 communicates the current directory as a `file://` URL to the terminal
emulator. This enables features like:
- Terminal.split-current-working-directory (Alacritty, Kitty, iTerm2)
- tmux/Zellij per-pane directory tracking
- "Open terminal here" from file managers
- Jump-to-directory in terminal multiplexer sessions

Without OSC 7, the terminal has no reliable way to know which directory each
shell session is in, especially after `cd` operations.

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
- [nushell-config-shell-integration-osc2](file://.opencode/skills/nushell-config-shell-integration-osc2.md)
- [nushell-config-shell-integration-osc133](file://.opencode/skills/nushell-config-shell-integration-osc133.md)
