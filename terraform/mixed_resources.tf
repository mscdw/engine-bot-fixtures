# Mixed resources -- exercises engine-bot's silent-skip paths
# alongside one resource type that DOES have a bundle.
#
# Expected bot behaviour against
# mscdw/engine-bundles@manual-9f38ef5a70db:
#
#   google_storage_bucket.target  -- HAS bundle;  surfaces the same
#                                    4 findings as the gcp-storage-bucket-
#                                    gaps fixture (now 3 since the
#                                    public_access_prevention suggestion
#                                    is what bot will suggest fresh here)
#
#   google_service_account.skip_a -- google_* prefix maps to schema_
#                                    namespace=gcp;  but the smoke release
#                                    has no bundle for this resource type.
#                                    Bot silently skips, no finding, no error.
#
#   aws_alb.skip_b               -- aws_* prefix maps to schema_namespace=
#                                    aws;  GCP-only smoke release has zero
#                                    aws bundles.  Same silent-skip path.

resource "google_storage_bucket" "target" {
  name     = "engine-bot-fixtures-mixed"
  location = "US"
}

resource "google_service_account" "skip_a" {
  account_id   = "engine-bot-skip-a"
  display_name = "deliberately-no-bundle"
}

resource "aws_alb" "skip_b" {
  name               = "engine-bot-skip-b"
  internal           = false
  load_balancer_type = "application"
  subnets            = ["subnet-placeholder"]
}
