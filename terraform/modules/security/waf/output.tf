output "waf_acl_arn" {
  value       = aws_wafv2_web_acl.waf_acl.arn
  description = "The ARN of the WAF ACL"
}

output "waf_acl_id" {
  value       = aws_wafv2_web_acl.waf_acl.id
  description = "The ID of the WAF ACL , for the ALB/API/CloudFront"
}