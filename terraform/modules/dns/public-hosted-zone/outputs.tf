output "zone_id" {
  value = aws_route53_zone.public.zone_id
}

output "ns_records" {
  value = aws_route53_zone.public.name_servers
}
