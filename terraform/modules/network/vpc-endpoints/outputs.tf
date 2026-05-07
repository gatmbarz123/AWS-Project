output "id" {
  value = aws_vpc_endpoint.vpce.id
}
output "network_interface_ids" {
  value = aws_vpc_endpoint.vpce.network_interface_ids
}

output "security_group_id" {
  value = aws_security_group.vpce.id
}

output "security_group_arn" {
  value = aws_security_group.vpce.arn
}