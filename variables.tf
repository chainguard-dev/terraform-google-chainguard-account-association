variable "environment" {
  default     = "enforce.dev"
  type        = string
  description = "Domain name of your Chainguard  environment"
  sensitive   = false
  nullable    = false
}

variable "group_ids" {
  type        = list(string)
  description = "Chainguard IAM group IDs to bind your GCP project to."
  sensitive   = false

  validation {
    condition     = can([for g in var.group_ids : regex("^[a-f0-9]{40}(\\/[a-f0-9]{16})*$", g)])
    error_message = "IDs must be a valid group id."
  }
}

variable "project_id" {
  type        = string
  description = "GCP Project ID"
  sensitive   = false
  nullable    = false
}
