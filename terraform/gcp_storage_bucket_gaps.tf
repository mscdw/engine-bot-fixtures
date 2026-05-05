# Deliberate non-compliance.  Brownfield consumer's hand-authored TF
# with no awareness of engine's canonical compliance gates.  Used as
# the smoke target for engine-bot's suggest mode end-to-end run.
#
# Expected findings (4) when scanned against
# mscdw/engine-bundles@manual-9f38ef5a70db's google_storage_bucket bundle:
#
#   MISSING_ATTRIBUTE  public_access_prevention      ckv-gcp-114
#   MISSING_ATTRIBUTE  uniform_bucket_level_access   ckv-gcp-29 (+ kics concurring)
#   MISSING_BLOCK      logging                       ckv-gcp-63
#   MISSING_BLOCK      versioning                    ckv-gcp-78

resource "google_storage_bucket" "fixtures" {
  name     = "engine-bot-fixtures-bucket"
  location = "US"
  public_access_prevention = "enforced"
}

# Synchronize-event smoke:  a second non-compliant block added in
# a follow-up commit to the same PR.  Bot's auto-trigger should
# fire on synchronize, post NEW comments for this block, leave
# the existing comments on the original block untouched
# (idempotency).
resource "google_storage_bucket" "fixtures_two" {
  name     = "engine-bot-fixtures-bucket-two"
  location = "US"
}
