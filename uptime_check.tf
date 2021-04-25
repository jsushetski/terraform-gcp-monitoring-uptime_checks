resource "google_monitoring_uptime_check_config" "uptime_check" {
  provider = google

  display_name = var.tcp_port == null ? "${var.host} HTTP(S) Check" : "${var.host} TCP Check on port ${var.tcp_port}"

  timeout = "${var.timeout}s"

  selected_regions = var.uptime_check_regions

  period = var.period

  dynamic "http_check" {
    for_each = var.tcp_port == null ? [""] : []

    content {
      path         = var.http_path
      port         = var.http_port
      use_ssl      = var.check_ssl
      validate_ssl = var.check_ssl ? var.validate_ssl : null
      mask_headers = false
      headers      = {}
    }
  }

  dynamic "tcp_check" {
    for_each = var.tcp_port == null ? [] : [""]

    content {
      port = var.tcp_port
    }
  }

  monitored_resource {
    type = "uptime_url"
    labels = {
      host = var.host
      project_id = var.project
    }
  }
}
