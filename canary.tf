// The service account to impersonate
resource "google_service_account" "chainguard_canary" {
  project    = local.project_id
  account_id = "chainguard-canary"
  depends_on = [google_project_service.iamcredentials-api]
}

// Allow the provider (mapped token) to impersonate this service account if
// the subject matches what we expect.
resource "google_service_account_iam_member" "allow_canary_impersonation" {
  for_each = toset(local.enforce_group_ids)

  service_account_id = google_service_account.chainguard_canary.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.chainguard_pool.name}/attribute.sub/canary:${each.value}"
}
