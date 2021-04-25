module "alert_policy" {
  source = "git::https://github.com/jsushetski/terraform-gcp-monitoring-alert_policies.git?ref=main"

  project = var.project

  display_name = var.tcp_port == null ? "${var.host} HTTP(S) Availability" : "${var.host} TCP Check"

  conditions = [
    {
      display_name         = var.tcp_port == null ? "HTTP(S) Check on ${var.host}" : "TCP Check of ${var.host} on port ${var.tcp_port}"
      comparison           = "COMPARISON_GT"
      duration             = 60
      filter               = "metric.type=\"monitoring.googleapis.com/uptime_check/check_passed\" resource.type=\"uptime_url\" metric.label.\"check_id\"=\"${google_monitoring_uptime_check_config.uptime_check.uptime_check_id}\""
      threshold_value      = 1
      alignment_period     = 1200
      cross_series_reducer = "REDUCE_COUNT_FALSE"
      group_by_fields = [
        "resource.*",
      ]
      per_series_aligner = "ALIGN_NEXT_OLDER"
      trigger = {
        count = 1
      }
    },
  ]
}
