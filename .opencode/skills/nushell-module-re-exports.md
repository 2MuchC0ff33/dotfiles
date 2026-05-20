# Re-Exports Use Export Use

## Description
Re-exports use `export use` to flatten a submodule's names into the parent namespace when that is the intentional design.

## When to Load
Load this skill when re-exporting symbols from submodules into a parent module's public API.

## Source
STANDARDS.adoc §11.5.6 (lines 4246–4258, 4308)

## Key Rules

- SHOULD: Re-exports use `export use` to flatten namespace
- FORBIDDEN: Wildcard re-exports that pull in unexpected names

## Rationale

`export use` re-exports specific names from a module into the current module's namespace, making them available without the submodule prefix. Always use explicit name lists, never wildcards, to avoid pulling in unintended symbols.

## Example

```nu
# CORRECT — selective re-export
export use utils.nu [format_date, parse_csv]

# CORRECT — re-export all intended public API
export use text.nu [trim, capitalize, slugify]

# INCORRECT — wildcard re-exports pull in everything
export use utils.nu *             # might include private helpers, constants, etc.

# CORRECT — re-export with rename
export use utils.nu [format_date as fmt_date]

# utils.nu
export def format_date [] { ... }
export def parse_csv [] { ... }
export def internal-helper [] { ... }   # also re-exported by wildcard!

# main.nu
export use utils.nu *                   # internal-helper now in public API!
```

## Related Skills
- nushell-module-export-minimal
- nushell-module-submodules
- nushell-module-private-helpers
