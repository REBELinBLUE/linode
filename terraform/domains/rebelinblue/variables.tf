variable "domain_apex" {
  type = string
}

variable "soa_email" {
  type = string
}

variable "ipv4_address" {
  type = string

  # validation {
  // can(cidrhost(var.string_like_valid_ipv4_cidr, 0)) - https://dev.to/drewmullen/terraform-variable-validation-with-samples-1ank
  #   condition     = can(cidrnetmask("${var.ipv4_address}/32") == var.ipv4_address)
  #   error_message = "Must be a valid IPv4 CIDR block address."
  # }
}

variable "ipv6_address" {
  type = string

  # validation {
  #   condition = can(cidrhost("::/128", var.ipv6_address) == var.ipv6_address)
  #   error_message = "Invalid IPv6 address format. Please provide a valid IPv6 address."
  # }
}

variable "default_tags" {
  type = list(string)
}
