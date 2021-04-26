variable "enable_alert_policy" {
  type        = bool
  default     = true
  description = "Enables alert policy configuration for the uptime check."
}

variable "host" {
  type        = string
  description = "The host monitored by the uptime check."
}

variable "http_path" {
  type        = string
  default     = "/"
  description = "The path monitored by a HTTP(S) uptime check."
}

variable "http_port" {
  type        = number
  default     = 443
  description = "The port a HTTP(S) check is run against."

  validation {
    condition     = can(var.http_port >= 1 && var.http_port <= 65535)
    error_message = "The value of 'http_port' must be between 1 and 65535."
  }
}

variable "notification_channels" {
  type        = list(string)
  default     = []
  description = "A list of notification channels configured in the alert policy configured for this uptime check."
}

variable "period" {
  type        = number
  default     = 60
  description = "How often, in seconds, the uptime check is performed."

  validation {
    condition     = contains([60, 300, 600, 900, ], var.period)
    error_message = "The specified period is not valid."
  }
}

variable "project" {
  type        = string
  description = "GCP project name."
}

variable "tcp_port" {
  type        = number
  default     = null
  description = "The port a TCP check is run against."

  validation {
    condition     = try((var.tcp_port >= 1 && var.tcp_port <= 65535), true)
    error_message = "The value of 'tcp_port' must be between 1 and 65535."
  }
}

variable "timeout" {
  type        = number
  default     = 10
  description = "The maximum amount of time in seconds to wait for checks to complete."

  validation {
    condition     = var.timeout >= 1 && var.timeout <= 60
    error_message = "The value of 'timeout' must be between 1 and 60."
  }
}

variable "uptime_check_regions" {
  type        = list(string)
  default     = ["USA", ]
  description = "The region(s) uptime checks are run from."

  validation {
    condition     = length(setsubtract(var.uptime_check_regions, ["USA", ])) == 0
    error_message = "The specified uptime check region(s) are not valid."
  }
}

variable "check_ssl" {
  type        = bool
  default     = true
  description = "Enables SSL checking for HTTP checks."
}

variable "validate_ssl" {
  type        = bool
  default     = true
  description = "Enables SSL certificate validation when SSL checks are enabled."
}
