# engine-bot-fixtures

Stable test targets for [`engine-bot`](https://github.com/mscdw/engine-bot)
end-to-end runs.

This repo holds **deliberately non-compliant Terraform** on feature branches +
open pull requests, so engine-bot's `suggest` mode has a known target to scan
against without needing to spin up a fresh PR every smoke test.

## Layout

- `terraform/baseline/` — minimal TF on `main`, no compliance gaps.
- `terraform/gcp_storage_bucket_gaps.tf` — committed on the
  `gcp-storage-bucket-gaps` branch, opens [PR #1](https://github.com/mscdw/engine-bot-fixtures/pulls)
  against `main`. Contains a `google_storage_bucket` block missing
  `public_access_prevention`, the `versioning {}` block, and the
  `logging {}` block. Bot's smoke-run expectation: 4 findings.

## Why a separate repo

Engine-bot is the agent. Tests of the agent need a PR-shaped target,
which means a real GitHub repo with real branches + PRs. Putting that
inside `engine-bot` would muddy the agent's git history with fixture
churn; keeping it here means each engine-bot run is reproducible
against a stable URL.

## Adding a new fixture

1. `git checkout -b <fixture-name>` off `main`.
2. Add a TF file under `terraform/<fixture-name>.tf` with the
   non-compliance you want to surface.
3. `git push -u origin <fixture-name>` and open a PR against `main`.
4. Document the expected findings in this README.
