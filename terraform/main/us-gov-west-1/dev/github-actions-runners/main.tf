module "github_actions_runners" {
  source = "../../../../modules/compute/github-actions-runner"

  prefix         = var.prefix
  aws_account_id = var.aws_account_id
  partition      = data.aws_partition.current.partition
  region         = var.region

  vpc_id     = data.aws_vpc.vpc.id
  subnet_ids = data.aws_subnets.private.ids

  ami_id        = var.ami_id
  instance_type = var.instance_type

  asg_min_size         = var.asg_min_size
  asg_max_size         = var.asg_max_size
  asg_desired_capacity = var.asg_desired_capacity

  github_config_url                 = var.github_config_url
  runner_labels                     = var.runner_labels
  github_app_id                     = var.github_app_id
  github_app_installation_id        = var.github_app_installation_id
  github_app_private_key_secret_arn = var.github_app_private_key_secret_arn

  scale_out_cpu_threshold = var.scale_out_cpu_threshold
  scale_in_cpu_threshold  = var.scale_in_cpu_threshold

  log_retention_days          = var.log_retention_days
  kms_deletion_window_in_days = var.kms_deletion_window_in_days

  tags = var.tags
}
