region = "us-gov-west-1"

# EC2
ami_id        = "ami-0fcd6976411032a0e"
instance_type = "m5.xlarge"

# ASG
asg_min_size         = 2
asg_max_size         = 10
asg_desired_capacity = 2

# GitHub
github_config_url                 = "https://github.com/gatmbarz123/AWS-Project"
runner_labels                     = ["self-hosted", "linux", "x64", "gov", "prod"]
github_app_id                     = "3173972"
github_app_installation_id        = "118674393"
github_app_private_key_secret_arn = "arn:aws-us-gov:secretsmanager:us-gov-west-1:123456789012:secret:github-actions/github-app-private-key-ef2YRb"

# Scaling
scale_out_cpu_threshold = 80
scale_in_cpu_threshold  = 20

# Observability
log_retention_days = 90

# KMS
kms_deletion_window_in_days = 30
