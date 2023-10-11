variable "tags" {
  description = "list of tags for resources"
}

variable "env" {
  description = "name of the environment for resource naming"
}

variable "service" {
  description = "name of the service for resource naming"
}

variable "resource_suffix" {
  description = "resource suffix for resource naming e.g. 01"
}


variable "subnets" {
  description = "subnet the azure firewall will reside in"
}

variable "resourcegroup" {
  description = "Resource group the fw will reside in"
}
