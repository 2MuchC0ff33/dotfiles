#!/usr/bin/env nu
# check-deps.nu
# Verifies development environment integrity.
# Primary check: nix flake check (validates hermetic environment).
# Secondary check: confirms all §1.4.2 tools are present on host PATH.
# Note: On Alpine/musl, nix develop is blocked (glibc bash).
# Note: nu -c does NOT source env.nu — sourced explicitly below for
# nix store tool paths (P10 decommission).

if ($nu.env-path | path exists) {
    source ($nu.env-path)
}

def main []: nothing -> nothing {
    print "Checking development environment via Nix..."

    let nix_result = (^nix flake check o+e>| complete)
    if $nix_result.exit_code != 0 {
        error make {msg: $"nix flake check failed:\n(($nix_result.stderr? | default ""))"}
    }
    print $"(ansi green)nix flake check: PASS(ansi reset)"

    # All §1.4.2 tools — confirmed present on host at ~/.cargo/bin/
    # After P10 decommission, these will resolve to nix store paths instead.
    let tools = [nu rg fd bat delta sd dust procs btm eza xh jj just zoxide starship cargo oc]

    # LSP servers
    let lsp_tools = [rust-analyzer taplo nixd]

    # Formatters
    let fmt_tools = [topiary nixfmt]

    # Linters
    let lint_tools = [nu-lint vale]

    # MCP infrastructure — Node.js 22 LTS (npx) and uv
    let mcp_tools = [node npx uv]
    let all_tools = ($tools ++ $lsp_tools ++ $fmt_tools ++ $lint_tools ++ $mcp_tools)

    let results = ($all_tools | each {|t|
        let result = (^which $t o+e>| complete)
        {
            tool: $t
            pass: ($result.exit_code == 0)
            path: ($result.stdout | str trim)
        }
    })

    $results | table

    let failures = ($results | where not pass)
    if ($failures | length) > 0 {
        error make {
            msg: $"Missing tools on PATH: ($failures | get tool | str join ', ')"
        }
    }

    print $"(ansi green)All environment checks passed.(ansi reset)"
}
