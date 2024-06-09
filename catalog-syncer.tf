// The service account to impersonate
resource "google_service_account" "catalog-syncer" {
  project    = var.project_id
  account_id = "chainguard-catalog-syncer"
  depends_on = [google_project_service.iamcredentials-api]
}

// Allow the provider (mapped token) to impersonate this service account if
// the subject matches what we expect.
resource "google_service_account_iam_binding" "catalog-syncer-impersonation" {
  service_account_id = google_service_account.catalog-syncer.name
  role               = "roles/iam.workloadIdentityUser"
  members            = [for id in var.group_ids : "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.chainguard_pool.name}/attribute.sub/catalog-syncer:${id}"]
}

// Grant the service account permissions to access the resources it
// needs to fulfill its purpose.
resource "google_project_iam_member" "catalog-syncer-push" {
  project = var.project_id
  role    = "roles/artifactregistry.writer"
  member  = "serviceAccount:${google_service_account.catalog-syncer.email}"
}
