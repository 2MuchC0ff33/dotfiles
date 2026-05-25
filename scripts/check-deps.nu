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

    let tools = [nu rg fd bat delta sd dust procs btm eza xh jj just zoxide starship cargo oc]

<<<<<<< conflict 1 of 1
+++++++ xrsoxtns 32b05cb1 (rebased revision)
    let lsp_tools = [rust-analyzer taplo nixd]
    let fmt_tools = [topiary nixfmt]
    let lint_tools = [nu-lint vale]
    let mcp_tools = [node npx uv]
    let all_tools = ($tools ++ $lsp_tools ++ $fmt_tools ++ $lint_tools ++ $mcp_tools)

    let results = ($all_tools | each {|t|
%%%%%%% diff from: kulvnuyz bd32f56b "feat(mcp): add Node.js + uv to Nix devShell, configure MCP servers" (rebased revision)
\\\\\\\        to: nwpwoxut 00cc16a7 "fix(p14): complete migration cleanup" (parents of rebased revision)
-    # MCP infrastructure — Node.js 22 LTS (npx) and uv
-    let mcp_tools = [node npx uv]
-    let all_tools = ($tools ++ $mcp_tools)
-
-    let results = ($all_tools | each {|t|
+    let results = ($tools | each {|t|
>>>>>>> conflict 1 of 1 ends
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
