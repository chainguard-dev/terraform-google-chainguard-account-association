# Configure Chainguard service access.

Terraform module to connect Chainguard to your Google Cloud Platform project.

This module is needed to leverage certain service integrations from
[Chainguard](https://www.chainguard.dev).

## Usage
This module binds a Chainguard IAM group to a GCP project.

```terraform
data "google_project" "project" {
  project_id = var.project_id # You can omit this to use provider-defaults
}

module "chainguard-account-association" {
  source = "chainguard-dev/chainguard-account-association/gcp"

  group_ids  = [var.group_id]
  project_id = data.google_project.project.project_id
}

resource "chainguard_account_associations" "example" {
  name  = "example"
  group = var.group_id

  google {
    project_id     = data.google_project.project.project_id
    project_number = data.google_project.project.number
  }
}
```

## How does it work?

Chainguard has an OIDC identity provider. This module configures your GCP
project to recognize that OIDC identity provider and allows certain tokens
to bind to certain IAM roles.

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | n/a |
| <a name="provider_google-beta"></a> [google-beta](#provider\_google-beta) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google-beta_google_iam_workload_identity_pool.chainguard_pool](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_iam_workload_identity_pool) | resource |
| [google-beta_google_iam_workload_identity_pool_provider.chainguard_provider](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_iam_workload_identity_pool_provider) | resource |
| [google_project_iam_member.catalog-syncer-push](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |
| [google_project_service.iamcredentials-api](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_service) | resource |
| [google_service_account.catalog-syncer](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account) | resource |
| [google_service_account.chainguard_canary](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account) | resource |
| [google_service_account_iam_binding.allow_canary_impersonation](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account_iam_binding) | resource |
| [google_service_account_iam_binding.catalog-syncer-impersonation](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account_iam_binding) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_environment"></a> [environment](#input\_environment) | Domain name of your Chainguard  environment | `string` | `"enforce.dev"` | no |
| <a name="input_group_ids"></a> [group\_ids](#input\_group\_ids) | Chainguard IAM group IDs to bind your GCP project to. | `list(string)` | n/a | yes |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | GCP Project ID | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_provider_id"></a> [provider\_id](#output\_provider\_id) | GCP identity provider pool configured for Chainguard. |
<!-- END_TF_DOCS -->
