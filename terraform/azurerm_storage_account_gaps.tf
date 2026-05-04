# Deliberate non-compliance.  Brownfield consumer's hand-authored TF
# with no awareness of engine's canonical compliance gates.  Used as
# the Azure smoke target for engine-bot's suggest mode end-to-end run.
#
# Expected findings depend on which controls the canonical
# azurerm_storage_account bundle gates;  bot resolves the bundle via
# address tuple (terraform, azure, azurerm_storage_account) at the
# engine_sha pinned by --bundles-tag.  A bare azurerm_storage_account
# (with only the schema-required fields populated) should surface a
# handful of MISSING_ATTRIBUTE / MISSING_BLOCK findings (https-only,
# min_tls_version, public-network-access, blob_properties.versioning,
# etc.) covering the Checkov + Trivy + KICS + Regula consensus of
# Azure storage-account compliance gates.

resource "azurerm_storage_account" "fixtures" {
  name                     = "enginebotfixtures"
  resource_group_name      = "rg-engine-bot-fixtures"
  location                 = "eastus"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# Synchronize-event smoke:  a second non-compliant block in the same
# PR.  Bot's auto-trigger should post NEW comments for this block on
# the synchronize event without disturbing existing comments on the
# first block (idempotency via fingerprint).
resource "azurerm_storage_account" "fixtures_two" {
  name                     = "enginebotfixturestwo"
  resource_group_name      = "rg-engine-bot-fixtures"
  location                 = "eastus"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}
