---
name: nushell-naming-no-abbreviations
description: Description
compatibility: opencode
---

# Nushell Naming: FORBIDDEN — Abbreviations Where Full Words Exist

## Description
Abbreviations in identifiers are FORBIDDEN when a full, readable word form exists. Names must be self-documenting and unambiguous.

## When to Load
Load this skill when naming any identifier (variables, commands, parameters, flags, files) and considering shortened forms, or when reviewing existing code for readability issues.

## Source
STANDARDS.adoc §11.5.1 (lines 4027–4059)

## Key Rules

- FORBIDDEN: Abbreviated words where the full word is standard and reasonably short: `$usr_nm` → `$user_name`, `qry` → `query`.
- FORBIDDEN: Telegraphese or cryptic shortenings: `$cfg` → `$config`, `$info` → `$information` only if context requires, `$db_conn_str` → `$db_connection_string`.
- FORBIDDEN: Single-letter variable names except for loop counters (`$i`, `$n`) and mathematical conventions (`$x`, `$y`, `$k`, `$v` for key-value pairs).
- FORBIDDEN: Dropping vowels arbitrarily: `$usr_nm`, `$db_addr`, `$msg_cnt`.
- MANDATE: Use the full, conventional English word for every segment of an identifier.
- SHOULD: Keep names concise but complete. If a name becomes excessively long (>30 chars), consider restructuring rather than abbreviating.
- ACCEPTABLE: Universally understood abbreviations/initialisms that are more recognizable than the expanded form: `$http_status`, `$json_data`, `$db_connection` (where `db`, `http`, `json` are standard initialisms, not ad-hoc shortenings).

## Rationale

1. Code is read far more often than it is written. Abbreviations save typing time but cost exponentially more in reading time and cognitive load.
2. Nushell's type annotations and command signatures already provide structural clarity; abbreviated names undermine this by requiring the reader to decode intent.
3. Shell scripting has a historical culture of terse, cryptic naming (Perl, Bash). This standard explicitly rejects that culture in favor of explicitness.
4. IDE features (tab completion) and editor autocomplete eliminate the need for short names — modern tools reward descriptive naming.

## Examples

### CORRECT

```nu
let user_name = 'Alice'
let db_connection = open 'db.sqlite'
let query_result = $db | query $sql
let configuration = load 'config.toml'
let total_count = $items | length
let attachment_path = '/tmp/file.pdf'
let http_status_code = 200
let processed_record_count = 0
```

### INCORRECT

```nu
let usr_nm = 'Alice'             # abbreviation — FORBIDDEN
let db_conn = open 'db.sqlite'   # abbreviation (connection) — FORBIDDEN
let qry_res = $db | qry $sql     # abbreviation — FORBIDDEN
let cfg = load 'config.toml'     # abbreviation — FORBIDDEN
let tot_cnt = $items | len       # abbreviations — FORBIDDEN
let attach_path = '/tmp/file.pdf' # abbreviation — FORBIDDEN
let http_sts = 200               # obscure abbreviation — FORBIDDEN
let proc_rec_cnt = 0             # cryptic — FORBIDDEN
```

## Common Abbreviation Mappings

| FORBIDDEN | CORRECT |
|-----------|---------|
| `usr` | `user` |
| `nm` | `name` |
| `addr` | `address` |
| `conn` | `connection` |
| `cfg` | `config` |
| `qry` | `query` |
| `res` | `result` |
| `cnt` / `ct` | `count` |
| `num` | `number` |
| `msg` | `message` |
| `tmp` | `temp` (acceptable as widely known) or `temporary` |
| `info` | `info` (acceptable — universally understood initialism) |
| `db` | `db` (acceptable — universally understood initialism) |
| `http` | `http` (acceptable — standard protocol initialism) |
| `str` | `string` |
| `val` | `value` |
| `del` | `delete` |
| `init` | `initialize` (acceptable — widely known) |

## Related Skills

- [nushell-naming-variables-snake](file://.opencode/skills/nushell-naming-variables-snake.md)
- [nushell-naming-commands-kebab](file://.opencode/skills/nushell-naming-commands-kebab.md)
- [nushell-naming-files-kebab](file://.opencode/skills/nushell-naming-files-kebab.md)
