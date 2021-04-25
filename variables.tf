variable "host" {
  type = string
}

variable "http_path" {
  type    = string
  default = "/"
}

variable "http_port" {
  type    = number
  default = 443

  validation {
    condition = can(var.http_port >=1 && var.http_port <= 65535)
    error_message = "The value of 'http_port' must be between 1 and 65535."
  }
}

variable "notification_channels" {
  type    = list(string)
  default = []
}

variable "period" {
  type    = number
  default = 300

  validation {
    condition     = contains([60, 300, 600, 900,], var.period)
    error_message = "The specified period is not valid."
  }
}

variable "project" {
  type = string
}

variable "tcp_port" {
  type    = number

  validation {
    condition = can(var.tcp_port >=1 && var.tcp_port <= 65535)
    error_message = "The value of 'tcp_port' must be between 1 and 65535."
  }
}

variable "timeout" {
  type    = number
  default = 10

  validation {
    condition = var.timeout >= 1 && var.timeout <= 60
    error_message = "The value of 'timeout' must be between 1 and 60."
  }
}

variable "uptime_check_regions" {
  type    = list(string)
  default = ["USA",]

  validation {
    condition = length(setsubtract(var.uptime_check_regions, ["USA",])) == 0
    error_message = "The specified uptime check region(s) are not valid."
  }
}

variable "use_ssl" {
  type    = bool
  default = true
}

variable "validate_ssl" {
  type    = bool
  default = true
}
