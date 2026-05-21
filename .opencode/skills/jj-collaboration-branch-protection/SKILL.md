---
name: jj-collaboration-branch-protection
description: Description
compatibility: opencode
---

# jj-collaboration-branch-protection

## Description
Branch protection rules enforced at the GitHub hosting layer: `main` is protected with PR requirements, linear history, signed commits, and no force-pushes.

## When to Load
Load this skill when configuring repository settings, preparing a PR for merge, understanding why a push was rejected, or onboarding a team to the standard's collaboration model.

## Source
STANDARDS.adoc §10.4 (lines 3607–3624)

## Key Rules

- MANDATE: The `main` branch (git: `main`) MUST be protected at the hosting platform (GitHub).
- MANDATE: All merges to `main` MUST go through a pull request with at least 2 approvals.
- MANDATE: Stale reviews MUST be dismissed when new commits are pushed to the PR branch.
- MANDATE: Code owner reviews MUST be required (per `CODEOWNERS` file definitions).
- MANDATE: Linear history MUST be required — no merge commits on `main` (enforced by GitHub's "Require linear history" setting).
- MANDATE: All commits MUST be signed (enforced by GitHub's "Require signed commits" setting).
- MANDATE: Force pushes to `main` are FORBIDDEN ("No force pushes" rule).
- MANDATE: Deletion of the `main` branch is FORBIDDEN ("No deletions" rule).
- MANDATE: Conversation resolution MUST be required — all PR comments must be resolved before merge.
- SHOULD: Apply equivalent protection rules to other long-lived branches (e.g., `release/*`, `staging`) if they exist.
- SHOULD: Use GitHub's "Require status checks" to require CI passing before merge.

## Example

```bash
# These rules are set in GitHub repository settings (Settings > Branches)
# Equivalent gh CLI configuration:

gh api repos/:owner/:repo/branches/main/protection \
  --method PUT \
  --field required_status_checks='{"strict":true,"contexts":["ci"]}' \
  --field enforce_admins=true \
  --field required_pull_request_reviews='{"required_approving_review_count":2,"dismiss_stale_reviews":true,"require_code_owner_reviews":true}' \
  --field restrictions='{}'

# Since jj pushes real git commits, these rules apply transparently:
jj git push
# If main is protected and you try to push directly (not via PR):
# remote: error: GH006: Protected branch update failed for refs/heads/main.
# remote: error: At least 2 approving reviews are required.
# (push is rejected — use a PR instead)
```

## How branch protection interacts with jj

These rules are enforced at the **hosting platform** (GitHub), not the VCS layer. Since jj pushes real git commits through the standard git protocol:

- All existing GitHub protections apply unchanged to jj-pushed commits
- `jj git push` to `main` is rejected if the PR/approval/signing requirements aren't met
- Linear history enforcement works because jj never creates merge commits
- Signed commit enforcement works because jj signs commits through git's commit signing
- No special jj configuration is needed — jj is transparent to GitHub's branch protection

## Related Skills
- [jj-command-git-push](file://.opencode/skills/jj-command-git-push.md)
- [jj-collaboration-gh-cli](file://.opencode/skills/jj-collaboration-gh-cli.md)
- [jj-collaboration-git-fetch](file://.opencode/skills/jj-collaboration-git-fetch.md)
