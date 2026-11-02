---
name: SQLite Stage State
description: Use when changing schema, migrations, or stage result queries; covers bootstrap, checksummed migrations, DB path precedence, and no shell escapes.
---

# SQLite Stage State

## Files

- `sql/schema/001_init.sql`
- `sql/migrations/002_stage_index.sql`
- `sql/queries/stage_status.sql`
- `sh/db_bootstrap.sh`
- `sh/db_migrate.sh`

## Rules

- No `.shell`, `.system`, or `.load`.
- Migrations are checksummed with `cksum` and recorded in
  `schema_migration`.
- `DB_PATH` precedence: `FRAMEWORK_DB`, `DB_PATH`, local conf, main conf,
  default.
- Never commit the database.

## Check

```sh
cd ~/.local/src/dotfiles/framework
FRAMEWORK_DB=work/check.db sh/db_bootstrap.sh
FRAMEWORK_DB=work/check.db sh/db_migrate.sh
sqlite3 -noheader work/check.db "SELECT COUNT(*) FROM schema_migration;"
```
