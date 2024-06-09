output "provider_id" {
  description = "GCP identity provider pool configured for Chainguard."
  value       = google_iam_workload_identity_pool_provider.chainguard_provider.name
}
