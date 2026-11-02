---
name: WebSocket Plugin
description: Use when working on plugins/websocket; covers wss-only, allowlist matching, one-message I/O, fw_timeout, and make plugins.
---

# WebSocket Plugin

## Contract

- Only `wss://`.
- URL must match `FW_PLUGIN_WEBSOCKET_ALLOWLIST`.
- One message per invocation, stdin to file.
- Bounded by `fw_timeout 30`.
- Exit 3 on contract violation, 4 on missing `websocat`, 124 on timeout.

## Usage

```sh
cd ~/.local/src/dotfiles/framework
printf 'hello\n' | sh plugins/websocket/websocket.sh \
  wss://echo.websocket.events work/ws.out
```

## Gate

```sh
make plugins
```

Plugins are excluded from `make verify`.
