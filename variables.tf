variable "tags" {
  description = "Tags to be added to resource blocks."
  type        = map(string)
  default     = {}

  validation {
    condition     = var.tags["owner"] != ""
    error_message = "The owner tag is empty for the AWS resources. Please set the AWS owner tag in the root module."
  }
}

variable "cidr_block" {
  description = "This is the CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"

  validation {
    condition     = can(regex("^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)(/([0-9]|[12][0-9]|3[0-2]))$", var.cidr_block))
    error_message = "Invalid cidr_block, pattern should be \"<ip>/<netmask>\". example: \"192.168.0.0/16\" "
  }
}

variable "public_subnet" {
  description = "Boolean to enable public ip's within the subnet and make the subnet internet accessable."
  type        = bool
  default     = false
}

variable "region" {
  description = "The region for the provider to connect to."
  type        = string
  default     = ""

  validation {
    condition     = length(var.region) != 0
    error_message = "Region variable not set!"
  }
}

variable "ssh_allowed_from" {
  description = "If the subnet is public, this is the cidr block that is allowed to connect with SSH."
  type        = string
  default     = "0.0.0.0/0"

  validation {
    condition     = can(regex("^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)(/([0-9]|[12][0-9]|3[0-2]))$", var.ssh_allowed_from))
    error_message = "Invalid cidr_block, pattern should be \"<ip>/<netmask>\". example: \"192.168.0.0/16\" "
  }
}