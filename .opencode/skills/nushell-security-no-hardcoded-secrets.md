# No Hardcoded Secrets

## Description
FORBIDDEN: Hardcoded secrets/tokens/credentials in source code.

## When to Load
Load this skill when writing any code that handles API keys, tokens, passwords, or credentials.

## Source
STANDARDS.adoc §11.5.8 (lines 4307–4315)

## Key Rules

- CRITICAL — FORBIDDEN: Hardcoded secrets/tokens/credentials in source code
- HIGH — MANDATE: Credentials scoped with `with-env`, not set on `$env` directly
- HIGH — MANDATE: Secrets read from files/stdin, not passed as command-line arguments

## Rationale

Hardcoded secrets in source code are exposed in version control, CI logs, and code review. They cannot be rotated without changing code. Use environment variables, secret management services, or encrypted files.

## Example

```nu
# INCORRECT — hardcoded secret
$env.API_KEY = 'sk-1234567890abcdef'         # FORBIDDEN
let db_password = 'supersecret123'            # FORBIDDEN

# INCORRECT — secret in command-line argument (visible in ps)
^my-app --api-key (open --raw /secrets/api_key)   # FORBIDDEN

# CORRECT — environment variable (set externally, never in source)
let api_key = $env.API_KEY                     # set in CI/deployment

# CORRECT — read from file (scoped)
with-env {DB_PASS: (open --raw /secrets/db_pass)} {
    ^my-app
}

# CORRECT — scoped credential (not on $env)
with-env {API_TOKEN: (open --raw /run/secrets/api_token)} {
    ^curl -H $'Authorization: Bearer $env.API_TOKEN' https://api.example.com
}

# INCORRECT — global env credential
$env.API_TOKEN = (open --raw /secrets/token)   # leaks to child processes
```

## Related Skills
- nushell-security-credential-scoping
- nushell-security-temp-files
- nushell-security-external-prefix
