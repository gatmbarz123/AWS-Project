# General
variable "environment" {
  type = string
}
variable "region" {
  type = string
}
variable "prefix" {
  type = string
}
# Tags
variable "tags" {
  type = map(string)
}

