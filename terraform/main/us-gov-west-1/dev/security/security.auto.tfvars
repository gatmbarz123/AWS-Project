cloudtrail_centralized_s3_bucket_name = "mng-usgw1-example-cloudtrail-management-events"
cloudtrail_name                       = "management-events"
cloudtrail_log_group_class            = "STANDARD"
cloudtrail_admin_emails               = ["user@example.com"]
security_sources                      = ["aws.ec2", "aws.iam", "aws.kms", "aws.guardduty"]
security_detail_types                 = ["AWS API Call via CloudTrail", "GuardDuty Finding"]
security_event_names                  = ["CreateUser", "DeleteUser", "CreateAccessKey", "DeleteRole", "DeletePolicy", "AttachUserPolicy", "AttachRolePolicy", "AuthorizeSecurityGroupIngress", "CreateSecurityGroup", "DeleteSecurityGroup", "RunInstances", "TerminateInstances", "DisableKey", "ScheduleKeyDeletion", "DeleteAlias", "CreateKey"]
security_event_sources                = ["iam.amazonaws.com", "ec2.amazonaws.com", "kms.amazonaws.com", "guardduty.amazonaws.com"]
is_management_account                 = false
#------------------------------------------------------ AWS Cloudtrail

#------------------------------------------------------ AWS Config

config_centralized_s3_bucket_name = "mng-usgw1-limitsless-config-management-events"


config_rules = [
  {
    name              = "s3-bucket-encryption"
    source_identifier = "S3_BUCKET_SERVER_SIDE_ENCRYPTION_ENABLED"
  },
  {
    name              = "ec2-security-group"
    source_identifier = "INCOMING_SSH_DISABLED"
    }, {
    name              = "ebs-volume-encryption"
    source_identifier = "ENCRYPTED_VOLUMES"
  },
  {
    name              = "rds-instance-public-accessibility"
    source_identifier = "RDS_INSTANCE_PUBLIC_ACCESS_CHECK"
  },
  {
    name              = "vpc-flow-logs"
    source_identifier = "VPC_FLOW_LOGS_ENABLED"
  },
  {
    name              = "cloudtrail-enabled"
    source_identifier = "CLOUD_TRAIL_ENABLED"
  },
  {
    name              = "elb-https-listener"
    source_identifier = "ALB_HTTP_TO_HTTPS_REDIRECTION_CHECK"
  }
]


#-------------------------------------------------------------------------- WAF 

waf_ip_set_scope             = "REGIONAL"
waf_ip_set_addresses_version = "IPV4"
allowed_ip_addresses         = ["10.50.0.0/16"]


white_list = [
  {
    name                       = "waf-ip-set"
    priority                   = 0
    cloudwatch_metrics_enabled = true
    metric_name                = "waf-ip-set-metrics"
    sampled_requests_enabled   = true
  }
]


# #-----------------------------------------------------WAF IP SET ^
# 
#-----------------------------------------------------WAF ACL RULES v


waf_acl_scope  = "REGIONAL"
default_action = "block"

waf_rules = [
  {
    name                       = "AWSManagedRulesCommonRuleSet"
    priority                   = 1
    override_action            = "none"
    vendor_name                = "AWS"
    cloudwatch_metrics_enabled = true
    metric_name                = "AWS-AWSManagedRulesCommonRuleSet-metrics"
    sampled_requests_enabled   = true
  },
  {
    name                       = "AWSManagedRulesAmazonIpReputationList"
    priority                   = 2
    override_action            = "none"
    vendor_name                = "AWS"
    cloudwatch_metrics_enabled = true
    metric_name                = "AWS-AWSManagedRulesAmazonIpReputationList-metrics"
    sampled_requests_enabled   = true
  }
]


cloudwatch_metrics_enabled = true
metric_name                = "waf-acl-regional-metrics"
sampled_requests_enabled   = true

geo_allow_countries = ["US", "IL"]
