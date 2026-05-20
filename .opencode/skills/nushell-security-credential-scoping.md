# Credential Scoping

## Description
Credentials scoped with `with-env`, not set on `$env` directly. Secrets read from files/stdin, not passed as command-line arguments.

## When to Load
Load this skill when handling any credentials, tokens, API keys, or secrets.

## Source
STANDARDS.adoc §11.5.8 (lines 4365–4385, 4399–4405)

## Key Rules

- HIGH — MANDATE: Credentials scoped with `with-env`, not set on `$env` directly
- HIGH — MANDATE: Secrets read from files/stdin, not passed as command-line arguments
- CRITICAL — FORBIDDEN: Hardcoded secrets/tokens/credentials in source code

## Rationale

Setting secrets on `$env` directly leaks them to all child processes. Passing secrets as command-line arguments makes them visible in `ps` output. `with-env` scopes the secret to only the commands that need it, and file-based secrets avoid argument exposure.

## Example

```nu
# INCORRECT — credential on CLI (visible in ps)
^my-app --connect (open --raw /secrets/db_pass)   # FORBIDDEN

# INCORRECT — global env credential
$env.DB_PASS = (open --raw /secrets/db_pass)      # leaks to all children

# CORRECT — scoped credentials
with-env {DB_PASS: (open --raw /secrets/db_pass)} {
    ^my-app --connect $env.DB_PASS
}

# CORRECT — multiple scoped credentials
with-env {
    API_KEY: (open --raw /secrets/api_key)
    DB_PASS: (open --raw /secrets/db_pass)
} {
    ^my-app
}

# CORRECT — pipe secret from stdin (no argument exposure)
open --raw /secrets/token | ^my-app --read-token

# CORRECT — scoped credential for a single HTTP call
with-env {GITHUB_TOKEN: (open --raw /secrets/github_token)} {
    ^curl -H $'Authorization: token $env.GITHUB_TOKEN' https://api.github.com/user
}

# BETTER — read file inside with-env, not before
# The file path is not a secret; only the content is
with-env {TOKEN: (open --raw /run/secrets/token)} {
    ^app
}
```
