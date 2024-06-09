terraform {
  required_providers {
    chainguard = {
      source = "chainguard-dev/chainguard"
    }
  }
}

data "google_project" "current" {}

resource "chainguard_group" "root1" {
  name        = "demo root 1"
  description = "root group for demo1"
}

resource "chainguard_group" "root2" {
  name        = "demo root 2"
  description = "root group for demo2"
}

module "account_association" {
  source = "./../../"

  project_id = data.google_project.current.project_id
  group_ids  = [
    chainguard_group.root1.id,
    chainguard_group.root2.id,
  ]
}

resource "chainguard_account_associations" "demo1-chaingaurd-dev-binding" {
  name  = "example"
  group = chainguard_group.root1.id
  google {
    project_id     = data.google_project.current.project_id
    project_number = data.google_project.current.number
  }
}

resource "chainguard_account_associations" "demo2-chaingaurd-dev-binding" {
  name  = "example"
  group = chainguard_group.root2.id
  google {
    project_id     = data.google_project.current.project_id
    project_number = data.google_project.current.number
  }
}
