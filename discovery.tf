// The service account to impersonate
resource "google_service_account" "chainguard_discovery" {
  project    = local.project_id
  account_id = "chainguard-discovery"
  depends_on = [google_project_service.iamcredentials-api]
}

// Allow the provider (mapped token) to impersonate this service account if
// the subject matches what we expect.
resource "google_service_account_iam_binding" "allow_discovery_impersonation" {
  service_account_id = google_service_account.chainguard_discovery.name
  role               = "roles/iam.workloadIdentityUser"
  members            = [for id in local.enforce_group_ids : "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.chainguard_pool.name}/attribute.sub/discovery:${id}"]
}

///////////////////////////////////////////////////////////////////////////
//
// Grant the service account permissions to access the resources it
// needs to fulfill its purpose.  Any new service that is added here
// should also be added to the audit log filter below.
//
///////////////////////////////////////////////////////////////////////////
resource "google_project_iam_member" "discovery_cluster_viewer" {
  project = local.project_id
  role    = "roles/container.clusterViewer"
  member  = "serviceAccount:${google_service_account.chainguard_discovery.email}"
}

resource "google_project_iam_member" "discovery_run_viewer" {
  project = local.project_id
  role    = "roles/run.viewer"
  member  = "serviceAccount:${google_service_account.chainguard_discovery.email}"
}


///////////////////////////////////////////////////////////////////////////
//
// Configure a pubsub topic audit log sink, so that we can subscribe to
// updates in each of the services that we support discovering and
// monitoring.
//
///////////////////////////////////////////////////////////////////////////
resource "google_pubsub_topic" "gcp_auditlog_sink" {
  name = "chainguard-auditlogs"
}

// Allow our discovery identity to manage and consume subscriptions in the
// project containing the topic and service accounts.
// See also: https://groups.google.com/g/cloud-pubsub-discuss/c/DhfkLMWcRok
resource "google_project_iam_custom_role" "create_auditlog_subscriptions" {
  role_id     = "chainguardSubscriber"
  title       = "Chainguard Subscriber"
  description = "This role allows certain Chainguard service accounts to manage pub/sub subscriptions."
  permissions = [
    "pubsub.subscriptions.get",
    "pubsub.subscriptions.create",
    "pubsub.subscriptions.update",
    "pubsub.subscriptions.delete",
    "pubsub.subscriptions.consume",
  ]
}
resource "google_project_iam_member" "discover_auditlog_subscriber" {
  project = local.project_id
  role    = "projects/${local.project_id}/roles/${google_project_iam_custom_role.create_auditlog_subscriptions.role_id}"
  member  = "serviceAccount:${google_service_account.chainguard_discovery.email}"
}
resource "google_pubsub_topic_iam_member" "discovery_sink_subscriber" {
  project = google_pubsub_topic.gcp_auditlog_sink.project
  topic   = google_pubsub_topic.gcp_auditlog_sink.name
  role    = "roles/pubsub.subscriber"
  member  = "serviceAccount:${google_service_account.chainguard_discovery.email}"
}

// Set up the logging sink to send auditlog events to the
// pubsub topic.
resource "google_logging_project_sink" "gcp_auditlog_sink" {
  name = "chainguard-auditlogs"

  // Send audit logs to the pubsub topic created above.
  destination = "pubsub.googleapis.com/${google_pubsub_topic.gcp_auditlog_sink.id}"

  // Create a unique service account for performing writes
  // to the pubsub topic.
  unique_writer_identity = true

  // This determines the subset of the audit logs we receive.
  filter = <<EOT
LOG_ID("cloudaudit.googleapis.com/activity")
protoPayload.serviceName = ("run.googleapis.com" OR "container.googleapis.com")
EOT
}

// Attach a policy allowing the audit log sink's unique identity
// to publish to the topic.
resource "google_pubsub_topic_iam_member" "publisher" {
  project = google_pubsub_topic.gcp_auditlog_sink.project
  topic   = google_pubsub_topic.gcp_auditlog_sink.name
  role    = "roles/pubsub.publisher"
  member  = google_logging_project_sink.gcp_auditlog_sink.writer_identity
}
