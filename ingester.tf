// The service account to impersonate
resource "google_service_account" "chainguard_ingester" {
  project    = local.project_id
  account_id = "chainguard-ingester"
  depends_on = [google_project_service.iamcredentials-api]
}

// Allow the provider (mapped token) to impersonate this service account if
// the subject matches what we expect.
resource "google_service_account_iam_binding" "allow_ingester_impersonation" {
  service_account_id = google_service_account.chainguard_ingester.name
  role               = "roles/iam.workloadIdentityUser"
  members            = [for id in local.enforce_group_ids : "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.chainguard_pool.name}/attribute.sub/ingester:${id}"]
}

// Grant the service account permissions to access the resources it
// needs to fulfill its purpose.
resource "google_project_iam_member" "ingester_gcr_read" {
  project = local.project_id
  role    = "roles/storage.objectViewer"
  member  = "serviceAccount:${google_service_account.chainguard_ingester.email}"
}
