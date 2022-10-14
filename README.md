# Terraform Google Chainguard Account Association Module

Terraform module to connect Chainguard to your Google Cloud Platform project.

This module is needed if you're using [Chainguard
Enforce](https://www.chainguard.dev/chainguard-enforce) and:

- Your containers (along with potential signatures and SBOMs etc) are in
a private GCR registry
- Your signatures are created via Google KMS
- Your using managed (i.e agentless) clusters in GKE

## Usage

This module binds an Enforce IAM group to a GCP project. To set up the connect
in Enforce using the CLI run:

```
export ENFORCE_GROUP_ID="<<uidp of target Enforce IAM group>>
export GCP_PROJECT_NUMBER="<< project number >>"
export GCP_PROJECT_ID="<< project id >>"

chainctl iam group set-gcp $ENFORCE_GROUP_ID \
  --project-number $GCP_PROJECT_NUMBER \
  --project-id $GCP_PROJECT_ID
```

Or using our (soon to be released publically) Terraform provider

```Terraform
resource "chainguard_account_associations" "example" {
  group = "<< enforce group id>>"
  google {
    project_id     = "<< project id >>"
    project_number = "<< project number >>"
  }
}
```

To configured the connection on AWS side use this module as follows:

```Terraform
module "chainguard-account-association" {
  source = "chainguard-dev/chainguard-account-association/aws"

  enforce_group_id = "<< enforce group id>>"
}
```

## How does it work?

Chainguard Enforce has an OIDC identity provider. This module configured your
GCP project to recognize that OIDC identity provider and allows certain tokens
to bind to certain IAM roles. In particular it allows:

- Our policy controller to bind to a role that gives us read access to your GCR
  registry to check signatures
- Our policy controller public key read access to your KMS keys to validate KMS
  signatures
- Our agentless controller to list and describe GKE clusters if using managed
  clusters

This access is restricted to clusters and policies you've configured at or
below the scope of the Enforce group you configure.

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
| [google-beta_google_iam_workload_identity_pool.chainguard_pool](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/iam_workload_identity_pool) | resource |
| [google-beta_google_iam_workload_identity_pool_provider.chainguard_provider](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/iam_workload_identity_pool_provider) | resource |
| [google_project_iam_member.agentless_gke_read](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_project_iam#google_project_iam_member) | resource |
| [google_project_iam_member.cosigned_gcr_read](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_project_iam#google_project_iam_member) | resource |
| [google_project_iam_member.cosigned_kms_pki_read](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_project_iam#google_project_iam_member) | resource |
| [google_project_iam_member.cosigned_kms_read](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_project_iam#google_project_iam_member) | resource |
| [google_project_service.iamcredentials-api](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_project_service) | resource |
| [google_service_account.chainguard_agentless](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_service_account) | resource |
| [google_service_account.chainguard_canary](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_service_account) | resource |
| [google_service_account.chainguard_cosigned](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_service_account) | resource |
| [google_service_account_iam_member.allow_agentless_impersonation](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_project_iam#google_project_iam_member) | resource |
| [google_service_account_iam_member.allow_canary_impersonation](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_project_iam#google_project_iam_member) | resource |
| [google_service_account_iam_member.allow_cosigned_impersonation](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_project_iam#google_project_iam_member) | resource |
| [google_project.provider_default](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_project) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_enforce_domain_name"></a> [enforce\_domain\_name](#input\_enforce\_domain\_name) | Domain name of your Chainguard Enforce environment | `string` | `"enforce.dev"` | no |
| <a name="input_enforce_group_id"></a> [enforce\_group\_id](#input\_enforce\_group\_id) | Enforce IAM group ID to bind your AWS account to | `string` | n/a | yes |
| <a name="input_google_project_id"></a> [google\_project\_id](#input\_google\_project\_id) | GCP Project ID. If not set, will default to provider default project id | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_provider_id"></a> [provider\_id](#output\_provider\_id) | GCP identity provider pool configured for Enforce |
<!-- END_TF_DOCS -->
