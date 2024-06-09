// Providers define the scopes at which Chainguard services may impersonate
// the service accounts associated with the enclosing pool.
// The "allowed_audiences" field below should encode the set of Chainguard
// IAM Group UIDPs at which impersonation has been allowed.

// Provision the provider (under the pool) that supports mapping identity tokens
// for this environment of Chainguard.
resource "google_iam_workload_identity_pool_provider" "chainguard_provider" {
  project                            = var.project_id
  provider                           = google-beta
  workload_identity_pool_id          = google_iam_workload_identity_pool.chainguard_pool.workload_identity_pool_id
  workload_identity_pool_provider_id = "chainguard-provider" # This gets 4-32 alphanumeric characters (and '-')
  display_name                       = "Chainguard provider"
  description                        = "This is the provider for impersonation by Chainguard services (environment: ${var.environment})."

  attribute_mapping = {
    "google.subject" = "assertion.sub"
    "attribute.sub"  = "assertion.sub"
  }
  oidc {
    allowed_audiences = ["google"]
    issuer_uri        = "https://issuer.${var.environment}"
  }
}

// Enable the API to support impersonation.
resource "google_project_service" "iamcredentials-api" {
  project                    = var.project_id
  service                    = "iamcredentials.googleapis.com"
  disable_dependent_services = false
  disable_on_destroy         = false
}

// Provision the Workload Identity Pool
resource "google_iam_workload_identity_pool" "chainguard_pool" {
  project                   = var.project_id
  provider                  = google-beta
  workload_identity_pool_id = "chainguard-pool"
  display_name              = "Chainguard Pool"
  description               = "Identity pool for Chainguard impersonation."
  depends_on                = [google_project_service.iamcredentials-api]
}
