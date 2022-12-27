// The service account to impersonate
resource "google_service_account" "chainguard_agentless" {
  project    = local.project_id
  account_id = "chainguard-agentless"
  depends_on = [google_project_service.iamcredentials-api]
}

// Allow the provider (mapped token) to impersonate this service account if
// the subject matches what we expect.
resource "google_service_account_iam_binding" "allow_agentless_impersonation" {
  service_account_id = google_service_account.chainguard_agentless.name
  role               = "roles/iam.workloadIdentityUser"
  members            = [for id in local.enforce_group_ids : "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.chainguard_pool.name}/attribute.sub/agentless:${id}"]
}

// Grant the service account permissions to access the resources it
// needs to fulfill its purpose.
resource "google_project_iam_member" "agentless_gke_read" {
  project = local.project_id
  role    = "roles/container.admin" # container.developer doesn't give access to webhooks
  member  = "serviceAccount:${google_service_account.chainguard_agentless.email}"
}
