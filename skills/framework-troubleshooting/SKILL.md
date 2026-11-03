---
name: Framework Troubleshooting
description: Use when a framework gate fails; maps common failures to causes and the correct fix without weakening gates.
---

# Framework Troubleshooting

## Map

| Symptom | Cause | Fix |
|---|---|---|
| `ENV_MISSING` | tool or file absent | install tool; check path |
| `TOOL_CONTRACT` | banned pattern | remove it; do not edit the rule |
| `PROOF_FAILED` | bad `.refine` | fix the literal; run `make proof` |
| `BYTECODE` | header/count mismatch | `make clean && make build` |
| `CHECKSUM` | edited file | `make checksum` |
| `MAN` | macro or empty render | fix `.1`; run `make man` |
| `C_STANDARD` | wrong `-std` | use `-std=c99` |
| LSP diagnostic | type/global error | fix code; do not disable |

## Rule

Never weaken a gate to make it pass. If a gate is wrong, change it in a
separate reviewed commit with a negative test.
