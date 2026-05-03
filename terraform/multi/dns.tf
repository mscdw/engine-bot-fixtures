# Non-compliant google_dns_managed_zone -- different resource type,
# different bundle.  Validates engine-bot can fetch + resolve TWO
# distinct bundles in a single PR scan + post comments to the right
# files.

resource "google_dns_managed_zone" "multi_b" {
  name        = "engine-bot-multi-b"
  dns_name    = "engine-bot-fixtures.example."
  description = "smoke target"
}
