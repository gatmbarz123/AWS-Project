variable "vpc_id" {
  type        = string
  description = "The VPC ID to associate with the Route 53 zone."
}

variable "zone_id" {
  type        = string
  description = "The Route 53 zone ID to associate with the VPC."
}
