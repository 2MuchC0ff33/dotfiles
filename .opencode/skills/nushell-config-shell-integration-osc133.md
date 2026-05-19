# nushell-config-shell-integration-osc133

## Description
Enable OSC 133 shell integration sequences for semantic prompt marking (prompt start, command start, command end).

## When to Load
Load this skill when configuring `$env.config.shell_integration.osc133` in `config.nu`.

## Source
STANDARDS.adoc §11.1 (line 3601)

## Key Rules

- MANDATE: `$env.config.shell_integration.osc133` MUST be `true`.
- SHOULD: OSC 133 marks prompt start (`A`), command start (`B`), and command end (`C`) so terminals can semantically select output, jump between prompts, and enable "scroll to previous prompt" features.
- FORBIDDEN: Setting `osc133 = false` or omitting this key.

## Rationale

OSC 133 (also known as the "FinalTerm" protocol or "semantic prompts") is the
most impactful shell integration feature. It emits escape sequences that
delimit:
- **Prompt start** (OSC 133 A): Marks where the prompt begins
- **Command start** (OSC 133 B): Marks where the user's command begins
- **Command end** (OSC 133 C): Marks where the command output ends

This enables terminal features such as:
- "Select output of last command" in Kitty, iTerm2, VS Code terminal
- "Scroll to previous/next prompt" navigation
- Semantic copy (copy command output only, not prompts)
- Jump-to-previous-error workflows
- Terminal multiplexer session logging with semantic boundaries

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
- [nushell-config-shell-integration-osc7](file://.opencode/skills/nushell-config-shell-integration-osc7.md)
