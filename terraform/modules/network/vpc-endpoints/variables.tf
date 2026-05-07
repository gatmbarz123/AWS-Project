# General
variable "prefix" {
  type = string
}

# VPC
variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "vpc_cidr_block" {
  type = string
}

# VPC Endpoints
variable "service_name" {
  type = string
}

variable "ip_address_type" {
  type = string
}

variable "vpc_endpoint_type" {
  type = string
}

variable "private_dns_enabled" {
  type = bool
}

variable "private_dns_only_for_inbound_resolver_endpoint" {
  type = bool
}

variable "name" {
  type = string
}

variable "sg_ingress_rules" {
  type = any
}

variable "route_table_ids" {
  type    = list(string)
  default = []
}
variable "tags" {
  type = map(string)
}
