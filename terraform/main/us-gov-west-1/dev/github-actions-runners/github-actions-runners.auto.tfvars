region = "us-gov-west-1"

# EC2
ami_id        = "ami-0fcd6976411032a0e"
instance_type = "m5.xlarge"

# ASG
asg_min_size         = 1
asg_max_size         = 3
asg_desired_capacity = 1

# GitHub
github_config_url                 = "https://github.com/gatmbarz123/AWS-Project"
runner_labels                     = ["self-hosted", "linux", "x64", "gov", "dev"]
github_app_id                     = "3173972"
github_app_installation_id        = "118674393"
github_app_private_key_secret_arn = "arn:aws-us-gov:secretsmanager:us-gov-west-1:123456789012:secret:github-actions/github-app-private-key-uYfqMf"

# Scaling
scale_out_cpu_threshold = 80
scale_in_cpu_threshold  = 20

# Observability
log_retention_days = 30

# KMS
kms_deletion_window_in_days = 30
