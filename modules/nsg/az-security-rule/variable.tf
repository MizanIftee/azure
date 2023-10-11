variable "nsg_name" {
  description = "Name of the nsg to create"
  type        = string
}
variable "resource_group" {}

variable "custom_rules" {
  description = "Security rules for the network security group using this format name = [priority, direction, access, protocol, destination_port_range, source_address_prefix, destination_address_prefix, description]"
  type        = any
  default     = []
}