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

// TODO(hectorj2f) Think about restricting cloudkms.cryptoKeyEncrypterDecrypter permissions to a keyring, e.g. key_ring_id = google_kms_key_ring.sigstore-keyring.id
resource "google_project_iam_custom_role" "chainguard_signer_ca_role" {
  project     = local.project_id
  role_id     = "chainguardSignerCA"
  title       = "Custom Role Chainguard Signer CA"
  description = "Chainguard signer role to list certificates from a CA"
  permissions = [
    "privateca.certificateAuthorities.list",
    "privateca.certificateAuthorities.get",
    "privateca.certificates.create",
    "cloudkms.cryptoKeyEncrypterDecrypter",
  ]
}

resource "google_project_iam_member" "signer_certificate_authorities" {
  project = local.project_id
  role    = "projects/${local.project_id}/roles/${google_project_iam_custom_role.chainguard_signer_ca_role.role_id}"
  member  = "serviceAccount:${google_service_account.chainguard_signer.email}"
}