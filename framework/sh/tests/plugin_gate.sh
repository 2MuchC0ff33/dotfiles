#!/bin/sh
set -eu

ROOT=$(CDPATH= cd "$(dirname "$0")/../.." && pwd)
cd "$ROOT"

. sh/lib/common.sh

sh -n plugins/websocket/websocket.sh
sh -n plugins/websocket/tests/websocket.sh
sh plugins/websocket/tests/websocket.sh
