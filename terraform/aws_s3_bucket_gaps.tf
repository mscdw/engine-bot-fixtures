# Deliberate non-compliance.  Brownfield consumer's hand-authored TF
# with no awareness of engine's canonical compliance gates.  Used as
# the AWS smoke target for engine-bot's suggest mode end-to-end run.
#
# Expected findings depend on which controls the canonical
# aws_s3_bucket bundle gates;  bot resolves the bundle via address
# tuple (terraform, aws, aws_s3_bucket) at the engine_sha pinned by
# --bundles-tag.  A bare aws_s3_bucket should surface a handful of
# MISSING_ATTRIBUTE / MISSING_BLOCK findings (encryption, versioning,
# public-access-block adjacency, logging, etc.) covering the
# Checkov + Trivy + KICS + Regula consensus of S3 compliance gates.

resource "aws_s3_bucket" "fixtures" {
  bucket = "engine-bot-fixtures-bucket"
}

# Synchronize-event smoke:  a second non-compliant block in the same
# PR.  Bot's auto-trigger should post NEW comments for this block on
# the synchronize event without disturbing existing comments on the
# first block (idempotency via fingerprint).
resource "aws_s3_bucket" "fixtures_two" {
  bucket = "engine-bot-fixtures-bucket-two"
}
