terraform {
  required_providers {
    chainguard = {
      source = "chainguard-dev/chainguard"
    }
  }
}

data "google_project" "current" {}

resource "chainguard_group" "root" {
  name        = "demo root"
  description = "root group for demo"
}

module "account_association" {
  source = "./../../"

  project_id = data.google_project.current.project_id
  group_ids  = [chainguard_group.root.id]
}

resource "chainguard_account_associations" "demo-chaingaurd-dev-binding" {
  name  = "example"
  group = chainguard_group.root.id
  google {
    project_id   = data.google_project.current.project_id
    project_number = data.google_project.current.number
  }
}
