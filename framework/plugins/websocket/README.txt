# WebSocket plugin

Opt-in transport plugin. It is enabled by default in `etc/framework.conf`
(`FW_PLUGINS=1`) but is excluded from `make verify`.

## Contract

- Only `wss://` URLs.
- The URL must match `FW_PLUGIN_WEBSOCKET_ALLOWLIST` (comma-separated).
- One message per invocation, read from stdin.
- Output is written atomically to the named file.
- The whole invocation is bounded by `fw_timeout 30`.

## Usage

```sh
printf 'hello\n' | sh plugins/websocket/websocket.sh \
  wss://echo.websocket.events work/ws.out
```

## Gate

```sh
make plugins
```

The gate checks scheme rejection, allowlist rejection, and the missing
dependency path. It does not perform live network I/O by default.

## Security

WebSocket transport is not an integrity or authentication mechanism. Use
`cksum` only for integrity, and never as a cryptographic hash.
