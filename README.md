# Terraform Google Chainguard Account Association Module

Terraform module to connect Chainguard to your Google Cloud Platform project.

This module is needed if you're using [Chainguard
Enforce](https://www.chainguard.dev/chainguard-enforce) and:

- Your containers (along with potential signatures and SBOMs etc) are in
a private GCR registry
- Your signatures are created via Google KMS
- Your using managed (i.e agentless) clusters in GKE
- You're setting up a certificate authority for keyless signing

## Usage
See [INSTALL.md](./INSTALL.md) for installation instructions.

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
| <a name="provider_null"></a> [null](#provider\_null) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google-beta_google_iam_workload_identity_pool.chainguard_pool](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_iam_workload_identity_pool) | resource |
| [google-beta_google_iam_workload_identity_pool_provider.chainguard_provider](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_iam_workload_identity_pool_provider) | resource |
| [google_logging_project_sink.gcp_auditlog_sink](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/logging_project_sink) | resource |
| [google_project_iam_custom_role.chainguard_signer_ca_role](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_custom_role) | resource |
| [google_project_iam_custom_role.create_auditlog_subscriptions](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_custom_role) | resource |
| [google_project_iam_member.agentless_gke_read](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |
| [google_project_iam_member.cosigned_gcr_read](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |
| [google_project_iam_member.cosigned_kms_pki_read](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |
| [google_project_iam_member.cosigned_kms_read](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |
| [google_project_iam_member.discover_auditlog_subscriber](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |
| [google_project_iam_member.discovery_cluster_viewer](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |
| [google_project_iam_member.discovery_run_viewer](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |
| [google_project_iam_member.ingester_gcr_read](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |
| [google_project_iam_member.signer_certificate_authorities](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |
| [google_project_service.iamcredentials-api](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_service) | resource |
| [google_pubsub_topic.gcp_auditlog_sink](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/pubsub_topic) | resource |
| [google_pubsub_topic_iam_member.discovery_sink_subscriber](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/pubsub_topic_iam_member) | resource |
| [google_pubsub_topic_iam_member.publisher](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/pubsub_topic_iam_member) | resource |
| [google_service_account.chainguard_agentless](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account) | resource |
| [google_service_account.chainguard_canary](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account) | resource |
| [google_service_account.chainguard_cosigned](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account) | resource |
| [google_service_account.chainguard_discovery](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account) | resource |
| [google_service_account.chainguard_ingester](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account) | resource |
| [google_service_account.chainguard_signer](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account) | resource |
| [google_service_account_iam_binding.allow_agentless_impersonation](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account_iam_binding) | resource |
| [google_service_account_iam_binding.allow_canary_impersonation](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account_iam_binding) | resource |
| [google_service_account_iam_binding.allow_cosigned_impersonation](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account_iam_binding) | resource |
| [google_service_account_iam_binding.allow_discovery_impersonation](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account_iam_binding) | resource |
| [google_service_account_iam_binding.allow_ingester_impersonation](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account_iam_binding) | resource |
| [google_service_account_iam_binding.allow_signer_impersonation](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account_iam_binding) | resource |
| [null_resource.enforce_group_id_is_specified](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [google_project.provider_default](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/project) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_enforce_domain_name"></a> [enforce\_domain\_name](#input\_enforce\_domain\_name) | Domain name of your Chainguard Enforce environment | `string` | `"enforce.dev"` | no |
| <a name="input_enforce_group_id"></a> [enforce\_group\_id](#input\_enforce\_group\_id) | DEPRECATED: Please use 'enforce\_group\_ids'. Enforce IAM group ID to bind your AWS account to | `string` | `""` | no |
| <a name="input_enforce_group_ids"></a> [enforce\_group\_ids](#input\_enforce\_group\_ids) | Enforce IAM group IDs to bind your AWS account to. If both 'enforce\_group\_id' and 'enforce\_group\_ids' are specified, 'enforce\_group\_id' is ignored. | `list(string)` | `[]` | no |
| <a name="input_google_project_id"></a> [google\_project\_id](#input\_google\_project\_id) | GCP Project ID. If not set, will default to provider default project id | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_provider_id"></a> [provider\_id](#output\_provider\_id) | GCP identity provider pool configured for Enforce |
<!-- END_TF_DOCS -->
