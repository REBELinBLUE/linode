variable "soa_email" {
  type = string
}

variable "ipv4_address" {
  type = string

  # validation {
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