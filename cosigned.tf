// The service account to impersonate
resource "google_service_account" "chainguard_cosigned" {
  project    = local.project_id
  account_id = "chainguard-cosigned"
  depends_on = [google_project_service.iamcredentials-api]
}

// Allow the provider (mapped token) to impersonate this service account if
// the subject matches what we expect.
resource "google_service_account_iam_binding" "allow_cosigned_impersonation" {
  service_account_id = google_service_account.chainguard_cosigned.name
  role               = "roles/iam.workloadIdentityUser"
  members            = [for id in local.enforce_group_ids : "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.chainguard_pool.name}/attribute.sub/cosigned:${id}"]
}

// Grant the service account permissions to access the resources it
// needs to fulfill its purpose.
resource "google_project_iam_member" "cosigned_gcr_read" {
  project = local.project_id
  role    = "roles/storage.objectViewer"
  member  = "serviceAccount:${google_service_account.chainguard_cosigned.email}"
}

resource "google_project_iam_member" "cosigned_kms_pki_read" {
  project = local.project_id
  role    = "roles/cloudkms.publicKeyViewer"
  member  = "serviceAccount:${google_service_account.chainguard_cosigned.email}"
}

// TODO(https://github.com/sigstore/sigstore/issues/467): remove this role when we can.
resource "google_project_iam_member" "cosigned_kms_read" {
  project = local.project_id
  role    = "roles/cloudkms.viewer"
  member  = "serviceAccount:${google_service_account.chainguard_cosigned.email}"
}
