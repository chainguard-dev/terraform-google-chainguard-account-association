output "provider_id" {
  value       = google_iam_workload_identity_pool_provider.chainguard_provider.name
  description = "GCP identity provider pool configured for Enforce"
}
