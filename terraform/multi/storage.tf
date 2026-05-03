# Non-compliant google_storage_bucket -- expected to surface 4
# findings (same as fixtures#1, since the resource has the same
# canonical bundle but no compliance attrs configured).

resource "google_storage_bucket" "multi_a" {
  name     = "engine-bot-multi-a"
  location = "US"
}
