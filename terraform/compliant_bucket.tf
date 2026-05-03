# Fully compliant google_storage_bucket -- every gated attribute the
# canonical bundle publishes is satisfied.  Smoke target for
# engine-bot's "OK path" -- bot should report ZERO findings, post
# nothing.  A bot run that surfaces ANY finding on this fixture is
# a false positive worth investigating.
#
# Gates satisfied (per mscdw/engine-bundles@manual-9f38ef5a70db):
#   ckv-gcp-114  public_access_prevention      = "enforced"
#   ckv-gcp-29   uniform_bucket_level_access   = true
#   ckv-gcp-63   logging.log_bucket            = (block present;  leaf is var-typed
#                                                in canonical, so block-existence is
#                                                what bot v1 checks)
#   ckv-gcp-78   versioning.enabled            = true

resource "google_storage_bucket" "compliant" {
  name     = "engine-bot-fixtures-compliant"
  location = "US"

  public_access_prevention    = "enforced"
  uniform_bucket_level_access = true

  versioning {
    enabled = true
  }

  logging {
    log_bucket = "engine-bot-fixtures-logs"
  }
}
