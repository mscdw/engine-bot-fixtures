# User-side var.X smoke target.
#
# This bucket has the gated attribute ``public_access_prevention``
# present BUT as a ``var.X`` reference -- bot's static analysis
# can't decide compliance for runtime-resolved values, so the
# finding for that attr should silently skip.  Other gated attrs
# the user omitted entirely (uniform_bucket_level_access, logging,
# versioning) should still surface.
#
# Expected findings (3 -- not 4):
#   MISSING_ATTRIBUTE  uniform_bucket_level_access  ckv-gcp-29
#   MISSING_BLOCK      logging                       ckv-gcp-63
#   MISSING_BLOCK      versioning                    ckv-gcp-78
#
# NOT expected:  any finding on public_access_prevention (var-side
# silent skip).

variable "pap" {
  type    = string
  default = "enforced"
}

resource "google_storage_bucket" "var_user" {
  name     = "engine-bot-fixtures-var-user"
  location = "US"

  public_access_prevention = var.pap
}
