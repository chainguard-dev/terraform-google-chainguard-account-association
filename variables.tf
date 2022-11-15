variable "enforce_domain_name" {
  default     = "enforce.dev"
  type        = string
  description = "Domain name of your Chainguard Enforce environment"
  sensitive   = false
  nullable    = false
}

variable "enforce_group_ids" {
  type        = list(string)
  description = "Enforce IAM group IDs to bind your AWS account to"
  sensitive   = false
  nullable    = false

  validation {
    condition     = length(var.enforce_group_ids) > 0
    error_message = "Must provide at least one id to enforce_group_ids."
  }
  validation {
    condition     = can([for g in var.enforce_group_ids : regex("^[a-f0-9]{40}(\\/[a-f0-9]{16})*$", g)])
    error_message = "IDs in enforce_group_ids must be a valid group id."
  }
}

variable "google_project_id" {
  default     = ""
  type        = string
  description = "GCP Project ID. If not set, will default to provider default project id"
  sensitive   = false
  nullable    = false
}
