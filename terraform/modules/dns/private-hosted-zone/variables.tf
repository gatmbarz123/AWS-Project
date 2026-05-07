variable "name" {
  description = "The name of the private hosted zone"
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC to associate with the private hosted zone"
  type        = string
}

variable "tags" {
  description = "A mapping of tags to assign to the private hosted zone"
  type        = map(string)
}

