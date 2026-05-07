resource "aws_route53_record" "dvo" {
  provider = aws.management
  name     = each.value.name
  records  = [each.value.record]
  ttl      = 60
  type     = each.value.type
  zone_id  = data.aws_route53_zone.public.zone_id


  for_each = {
    for dvo in var.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }
}


resource "aws_acm_certificate_validation" "cert" {
  provider                = aws
  certificate_arn         = var.certificate_arn
  validation_record_fqdns = [for record in aws_route53_record.dvo : record.fqdn]
}
