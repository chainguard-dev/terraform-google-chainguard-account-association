terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
    }
    google-beta = {
      source = "hashicorp/google-beta"
    }
    chainguard = {
      # NB: This provider is currently not public
      source = "chainguard/chainguard"
    }
  }
}

provider "chainguard" {
  console_api = "https://console-api.chainguard.dev"
}

provider "google" {}

provider "google-beta" {}

data "google_project" "current" {
}

resource "chainguard_group" "root" {
  name        = "demo root"
  description = "root group for demo"
}

module "account_association" {
  source = "./../../"

  google_project_id   = data.google_project.current.project_id
  enforce_domain_name = "chainguard.dev"
  enforce_group_id    = chainguard_group.root.id
  enforce_group_ids   = [chainguard_group.root.id, "000000"]
}

resource "chainguard_account_associations" "demo-chaingaurd-dev-binding" {
  group = chainguard_group.root.id
  google {
    project_id     = data.google_project.current.project_id
    project_number = data.google_project.current.number
  }
}
