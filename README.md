# engine-bot-fixtures

Stable test targets for [`engine-bot`](https://github.com/mscdw/engine-bot)
end-to-end runs across both modes (`suggest` and `drift`).

This repo holds **deliberately non-compliant or drifted Terraform**
on feature branches + open pull requests, so engine-bot has known
targets to scan against without needing to spin up fresh PRs every
smoke test.

## Why a separate repo

Engine-bot is the agent. Tests of the agent need a PR-shaped target,
which means a real GitHub repo with real branches + PRs. Putting that
inside `engine-bot` would muddy the agent's git history with fixture
churn; keeping it here means each engine-bot run is reproducible
against a stable URL.

## Active fixtures

All fixtures are **permanent open PRs** — they exist indefinitely as
deterministic engine-bot test targets. The bot's idempotency
(fingerprint-based for `suggest`, branch-name-based for `drift`)
means re-runs converge without piling up duplicate comments or PRs.

### `suggest` mode targets

| PR | Branch | Resource | Expected behavior |
|---|---|---|---|
| [#1](../../pull/1) | `gcp-storage-bucket-gaps` | `google_storage_bucket` | 4 findings on the original block + N findings on a second block (synchronize-event smoke target). DO NOT MERGE. |
| [#2](../../pull/2) | `compliant-bucket` | `google_storage_bucket` (fully compliant) | 0 findings — OK path validation. |
| [#3](../../pull/3) | `mixed-resources` | 3 resource types | 4 findings on `google_storage_bucket.target` only;  `google_service_account` + `aws_alb` silent-skip (no bundle for those). |
| [#4](../../pull/4) | `modify-existing` | `google_storage_bucket.modify_target` | 1 VALUE_DIVERGENCE (`uniform_bucket_level_access` flipped from `true` to `false`).  Tests file-modification scenario + line-anchoring inside diff hunk. |
| [#5](../../pull/5) | `readme-only` | (none -- README change only) | Workflow does NOT fire — `paths: ['**/*.tf']` filter validation. |
| [#6](../../pull/6) | `multi-file` | `google_storage_bucket` + `google_dns_managed_zone` | 5 findings split 4/1 across two files.  Tests multi-file scanning. |
| [#7](../../pull/7) | `var-on-user-side` | `google_storage_bucket.var_user` | 3 findings (NOT 4). `public_access_prevention = var.pap` silent-skip (var-typed user value). |

### `drift` mode targets

| PR | Branch | Source file | Expected behavior |
|---|---|---|---|
| [#8](../../pull/8) | (bot-owned `engine-bot/google_storage_bucket/uniform_bucket_level_access/9f38ef5a`) | `terraform/drift-already-broken/modules/core/main.tf` | Bot detects `uniform_bucket_level_access = false` drifted from canonical `true`, opens this PR with the fix.  Permanent open PR — DO NOT MERGE.  Drift mode's idempotency (deterministic branch name) means re-runs find this existing PR + skip. |

## Workflows

| Workflow | Trigger | Mode | Pin |
|---|---|---|---|
| `engine-bot.yml` | `pull_request` (`paths: ['**/*.tf']`) | `suggest --post` | `mscdw/engine-bot@v0.1.0` |
| `engine-bot-drift.yml` | `workflow_dispatch` (cron commented for manual control) | `drift --push` | `mscdw/engine-bot@v0.2.1` |

Both workflows pull `mscdw/engine-bot` as a private cross-repo
checkout via the `ENGINE_BOT_TOKEN` PAT secret (since `engine-bot`
is private during dev).  When `engine-bot` goes public the workflows
collapse to a single `uses: mscdw/engine-bot@<tag>` line.

## Adding a new fixture

1. `git checkout -b <fixture-name>` off `main`.
2. Add or modify TF under `terraform/<...>.tf`.
3. `git push -u origin <fixture-name>` and `gh pr create` against `main`.
4. Document the expected behavior in the table above.

## Cleanup notes

The drifted file at `terraform/drift-already-broken/modules/core/main.tf`
has `uniform_bucket_level_access = false`. The bot's drift workflow
detects this and opens [PR #8](../../pull/8) proposing the fix
(`= true`). Merging PR #8 would restore the file to canonical, but
that removes the smoke target — leave open instead.
