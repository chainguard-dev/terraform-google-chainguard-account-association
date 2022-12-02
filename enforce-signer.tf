// The service account to impersonate
resource "google_service_account" "chainguard_signer" {
  project    = local.project_id
  account_id = "chainguard-enforce-signer"
  depends_on = [google_project_service.iamcredentials-api]
}

// Allow the provider (mapped token) to impersonate this service account if
// the subject matches what we expect.
resource "google_service_account_iam_member" "allow_signer_impersonation" {
  service_account_id = google_service_account.chainguard_signer.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.chainguard_pool.name}/attribute.sub/enforce-signer:${var.enforce_group_id}"
}

resource "google_project_iam_member" "signer_cert_requester" {
  project = local.project_id
  role    = "roles/privateca.certificateRequester"
  member  = "serviceAccount:${google_service_account.chainguard_signer.email}"
}
