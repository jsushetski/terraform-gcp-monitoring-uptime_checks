locals {
  uptime_check = {
    display_name         = var.tcp_port == null ? "HTTP(S) Check on ${var.host}" : "TCP Check of ${var.host} on port ${var.tcp_port}"
    comparison           = "COMPARISON_GT"
    duration             = var.alert_duration
    filter               = "metric.type=\"monitoring.googleapis.com/uptime_check/check_passed\" resource.type=\"uptime_url\" metric.label.\"check_id\"=\"${google_monitoring_uptime_check_config.uptime_check.uptime_check_id}\""
    threshold_value      = 1
    alignment_period     = 1200
    cross_series_reducer = "REDUCE_COUNT_FALSE"
    group_by_fields = [
      "resource.*",
    ]
    per_series_aligner = "ALIGN_NEXT_OLDER"
    trigger_count      = 1
    trigger_percent    = 0
  }

  ssl_expiry_check = {
    display_name         = "SSL Expiry Check on ${var.host}"
    comparison           = "COMPARISON_LT"
    duration             = 60
    filter               = "metric.type=\"monitoring.googleapis.com/uptime_check/time_until_ssl_cert_expires\" resource.type=\"uptime_url\" resource.label.host=\"${var.host}\""
    threshold_value      = 30
    alignment_period     = 300
    cross_series_reducer = "REDUCE_MAX"
    group_by_fields      = []
    per_series_aligner   = "ALIGN_MEAN"
    trigger_count        = 1
    trigger_percent      = 0
  }
}

module "alert_policy" {
  source = "git::https://github.com/jsushetski/terraform-gcp-monitoring-alert_policies.git?ref=v1.0.0"

  enable = var.enable_alert_policy

  project = var.project

  display_name = var.tcp_port == null ? "${var.host} HTTP(S) Availability" : "${var.host} TCP Check"

  conditions_threshold = var.check_ssl ? [local.uptime_check, local.ssl_expiry_check, ] : [local.uptime_check, ]

  notification_channels = var.notification_channels
}
