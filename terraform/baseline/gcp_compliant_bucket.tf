# Baseline compliant bucket -- lives on main, no compliance gaps.
# The ``modify-existing`` feature branch flips one of these gates
# to a non-compliant value to test engine-bot's VALUE_DIVERGENCE
# finding kind on a MODIFIED file (vs the gcp-storage-bucket-gaps
# fixture which adds a new file).

resource "google_storage_bucket" "modify_target" {
  name     = "engine-bot-fixtures-modify-target"
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
