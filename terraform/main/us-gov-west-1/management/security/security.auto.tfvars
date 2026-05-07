s3_policy_path             = "../../../common/policies/bucket"
bucket_name_cloudtrail     = "example-cloudtrail-management-events"
cloudtrail_name            = "management-events"
cloudtrail_log_group_class = "STANDARD"
cloudtrail_admin_emails    = ["user@example.com"]
security_detail_types      = ["AWS API Call via CloudTrail", "GuardDuty Finding"]
security_sources           = ["aws.iam", "aws.guardduty"]
security_event_names       = ["CreateUser", "DeleteUser", "CreateAccessKey", "DeleteRole", "DeletePolicy", "AttachUserPolicy", "AttachRolePolicy"]
security_event_sources     = ["iam.amazonaws.com", "guardduty.amazonaws.com"]
is_management_account      = true
region                     = "us-gov-west-1"

# Accounts
dev_qa_account_id     = "123456789012"
production_account_id = "123456789012"
member_account_ids    = ["123456789012", "123456789012"]

#------------------------------------------------------ AWS Config

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

bucket_name_config = "limitsless-config-management-events"

#---------------------------------------------------------------------- AWS GuardDuty
guardduty_enable                 = true
auto_enable_organization_members = "ALL"

guardduty_configuration_features = {
  S3_DATA_EVENTS         = {}
  EKS_AUDIT_LOGS         = {}
  RDS_LOGIN_EVENTS       = {}
  EBS_MALWARE_PROTECTION = {}
  RUNTIME_MONITORING = {
    additional_configurations = [
      { name = "ECS_FARGATE_AGENT_MANAGEMENT", auto_enable = "NONE" },
      { name = "EC2_AGENT_MANAGEMENT", auto_enable = "NONE" },
      { name = "EKS_ADDON_MANAGEMENT", auto_enable = "NONE" },
    ]
  }
}
