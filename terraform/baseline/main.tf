# Baseline Terraform on main.  No compliance gaps -- engine-bot's
# smoke run on a PR vs main should never surface findings on these
# blocks (any finding on baseline = false positive worth investigating).

terraform {
  required_version = ">= 1.5"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.0"
    }
  }
}
