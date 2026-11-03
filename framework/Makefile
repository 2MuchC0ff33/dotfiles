.POSIX:

SHELL = /bin/sh
LUA = lua5.4
LUAC = luac5.4

.PHONY: all verify env audit shell parse lint format lsp test proof build checksum man c plugins verify-plugins clean ascii vcs

all: verify

verify: env audit shell parse lint format lsp test proof build checksum man c ascii vcs

env:
	sh/tests/env_probe.sh

audit:
	sh/tests/posix_scope_audit.sh

shell:
	sh/tests/shell_syntax.sh

parse:
	find lib tests -type f -name '*.lua' -exec $(LUAC) -p {} +

lint:
	luacheck --no-cache --codes --config .luacheckrc lib tests

format:
	stylua --check --verify --respect-ignores --syntax Lua54 lib tests

lsp:
	sh/tests/lsp_check.sh

test:
	sh/tests/run_all.sh

proof:
	sh/tests/run_proofs.sh

build:
	sh/build_bytecode.sh
	sh/tests/bytecode.sh

checksum:
	sh/checksum.sh
	sh/tests/checksum_verify.sh

man:
	sh/tests/man_gate.sh

ascii:
	sh/tests/ascii_gate.sh

vcs:
	sh/tests/vcs_gate.sh

c:
	sh/tests/c_gate.sh

plugins:
	sh/tests/plugin_gate.sh

verify-plugins: plugins

clean:
	rm -rf work build
	mkdir -p work build
