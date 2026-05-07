# ─── KMS ─────────────────────────────────────────────────────────────────────

data "aws_iam_policy_document" "kms_key_policy" {
  statement {
    sid    = "EnableRootAccess"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["arn:${var.partition}:iam::${var.aws_account_id}:root"]
    }
    actions   = ["kms:*"]
    resources = ["*"]
  }

  statement {
    sid    = "AllowRunnerRole"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = [aws_iam_role.runner.arn]
    }
    actions = [
      "kms:Decrypt",
      "kms:GenerateDataKey",
    ]
    resources = ["*"]
  }

  statement {
    sid    = "AllowCloudWatchLogs"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["logs.${var.region}.amazonaws.com"]
    }
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:GenerateDataKey",
      "kms:DescribeKey",
    ]
    resources = ["*"]
  }
}

resource "aws_kms_key" "this" {
  description              = "KMS key for GitHub Actions runners - ${var.prefix}"
  key_usage                = "ENCRYPT_DECRYPT"
  customer_master_key_spec = "SYMMETRIC_DEFAULT"
  enable_key_rotation      = true
  deletion_window_in_days  = var.kms_deletion_window_in_days
  policy                   = data.aws_iam_policy_document.kms_key_policy.json
  tags                     = var.tags
}

resource "aws_kms_alias" "this" {
  name          = "alias/${var.prefix}-github-actions-runner"
  target_key_id = aws_kms_key.this.key_id
}

# ─── IAM ─────────────────────────────────────────────────────────────────────

data "aws_iam_policy_document" "runner_assume_role" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "runner" {
  name               = "${var.prefix}-github-actions-runner"
  assume_role_policy = data.aws_iam_policy_document.runner_assume_role.json
  tags               = var.tags
}

resource "aws_iam_instance_profile" "runner" {
  name = "${var.prefix}-github-actions-runner"
  role = aws_iam_role.runner.name
}

data "aws_iam_policy_document" "runner_policy" {
  # Fetch GitHub App private key from Secrets Manager
  statement {
    sid       = "SecretsManagerGetAppKey"
    effect    = "Allow"
    actions   = ["secretsmanager:GetSecretValue"]
    resources = [var.github_app_private_key_secret_arn]
  }

  # SSM Session Manager – remote access without a bastion
  statement {
    sid    = "SSMSessionManager"
    effect = "Allow"
    actions = [
      "ssm:UpdateInstanceInformation",
      "ssmmessages:CreateControlChannel",
      "ssmmessages:CreateDataChannel",
      "ssmmessages:OpenControlChannel",
      "ssmmessages:OpenDataChannel",
      "ec2messages:AcknowledgeMessage",
      "ec2messages:DeleteMessage",
      "ec2messages:FailMessage",
      "ec2messages:GetEndpoint",
      "ec2messages:GetMessages",
      "ec2messages:SendReply",
    ]
    resources = ["*"]
  }

  # CloudWatch Logs
  statement {
    sid    = "CloudWatchLogs"
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogStreams",
    ]
    resources = ["${aws_cloudwatch_log_group.runner.arn}:*"]
  }

  # ECR – authorization token (account-scoped, no resource constraint)
  statement {
    sid       = "ECRAuth"
    effect    = "Allow"
    actions   = ["ecr:GetAuthorizationToken"]
    resources = ["*"]
  }

  # ECR – pull images
  statement {
    sid    = "ECRPull"
    effect = "Allow"
    actions = [
      "ecr:BatchGetImage",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchCheckLayerAvailability",
    ]
    resources = ["arn:${var.partition}:ecr:${var.region}:${var.aws_account_id}:repository/*"]
  }

  # S3 – runner cache bucket
  statement {
    sid    = "S3Cache"
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject",
      "s3:ListBucket",
    ]
    resources = [
      aws_s3_bucket.cache.arn,
      "${aws_s3_bucket.cache.arn}/*",
    ]
  }

  # KMS – decrypt S3 cache objects and CloudWatch Logs
  statement {
    sid    = "KMSDecrypt"
    effect = "Allow"
    actions = [
      "kms:Decrypt",
      "kms:GenerateDataKey",
    ]
    resources = [aws_kms_key.this.arn]
  }
}

resource "aws_iam_policy" "runner" {
  name   = "${var.prefix}-github-actions-runner"
  policy = data.aws_iam_policy_document.runner_policy.json
  tags   = var.tags
}

resource "aws_iam_role_policy_attachment" "runner" {
  role       = aws_iam_role.runner.name
  policy_arn = aws_iam_policy.runner.arn
}

# ─── Security Group ───────────────────────────────────────────────────────────

resource "aws_security_group" "runner" {
  name        = "${var.prefix}-github-actions-runner"
  description = "GitHub Actions runner - egress only"
  vpc_id      = var.vpc_id
  tags        = merge(var.tags, { Name = "${var.prefix}-github-actions-runner" })
}

resource "aws_security_group_rule" "runner_egress_https" {
  security_group_id = aws_security_group.runner.id
  type              = "egress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "HTTPS egress for GitHub APIs, ECR, S3, SSM"
}

resource "aws_security_group_rule" "runner_egress_http" {
  security_group_id = aws_security_group.runner.id
  type              = "egress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "HTTP egress for package manager installs"
}

# ─── S3 Cache Bucket ──────────────────────────────────────────────────────────

resource "aws_s3_bucket" "cache" {
  bucket = "${var.prefix}-github-runner-cache"
  tags   = var.tags
}

resource "aws_s3_bucket_server_side_encryption_configuration" "cache" {
  bucket = aws_s3_bucket.cache.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = aws_kms_key.this.arn
    }
    bucket_key_enabled = true
  }
}

resource "aws_s3_bucket_public_access_block" "cache" {
  bucket                  = aws_s3_bucket.cache.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

data "aws_iam_policy_document" "cache_bucket_policy" {
  statement {
    sid    = "AllowRunnerRole"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = [aws_iam_role.runner.arn]
    }
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject",
      "s3:ListBucket",
    ]
    resources = [
      aws_s3_bucket.cache.arn,
      "${aws_s3_bucket.cache.arn}/*",
    ]
  }

  statement {
    sid    = "DenyNonSSL"
    effect = "Deny"
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    actions = ["s3:*"]
    resources = [
      aws_s3_bucket.cache.arn,
      "${aws_s3_bucket.cache.arn}/*",
    ]
    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
  }
}

resource "aws_s3_bucket_policy" "cache" {
  bucket = aws_s3_bucket.cache.id
  policy = data.aws_iam_policy_document.cache_bucket_policy.json
}

# ─── CloudWatch ───────────────────────────────────────────────────────────────

resource "aws_cloudwatch_log_group" "runner" {
  name              = "/${var.prefix}/github-actions-runner"
  retention_in_days = var.log_retention_days
  kms_key_id        = aws_kms_key.this.arn
  tags              = var.tags
}

# ─── Launch Template ──────────────────────────────────────────────────────────

resource "aws_launch_template" "runner" {
  name_prefix   = "${var.prefix}-github-actions-runner-"
  image_id      = var.ami_id
  instance_type = var.instance_type

  iam_instance_profile {
    name = aws_iam_instance_profile.runner.name
  }

  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [aws_security_group.runner.id]
  }

  # Enforce IMDSv2
  metadata_options {
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
    instance_metadata_tags      = "enabled"
  }

  monitoring {
    enabled = true
  }

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size           = 50
      volume_type           = "gp3"
      delete_on_termination = true
      encrypted             = true
    }
  }

  user_data = base64encode(templatefile("${path.module}/userdata.sh.tpl", {
    REGION                            = var.region
    GITHUB_CONFIG_URL                 = var.github_config_url
    RUNNER_LABELS                     = join(",", var.runner_labels)
    GITHUB_APP_ID                     = var.github_app_id
    GITHUB_APP_INSTALLATION_ID        = var.github_app_installation_id
    GITHUB_APP_PRIVATE_KEY_SECRET_ARN = var.github_app_private_key_secret_arn
    LOG_GROUP                         = aws_cloudwatch_log_group.runner.name
    PREFIX                            = var.prefix
  }))

  tag_specifications {
    resource_type = "instance"
    tags          = merge(var.tags, { Name = "${var.prefix}-github-actions-runner" })
  }

  tag_specifications {
    resource_type = "volume"
    tags          = merge(var.tags, { Name = "${var.prefix}-github-actions-runner" })
  }

  lifecycle {
    create_before_destroy = true
  }
}

# ─── Auto Scaling Group ───────────────────────────────────────────────────────

resource "aws_autoscaling_group" "runner" {
  name                = "${var.prefix}-github-actions-runner"
  vpc_zone_identifier = var.subnet_ids
  min_size            = var.asg_min_size
  max_size            = var.asg_max_size
  desired_capacity    = var.asg_desired_capacity

  launch_template {
    id      = aws_launch_template.runner.id
    version = "$Latest"
  }

  health_check_type         = "EC2"
  health_check_grace_period = 300

  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
    }
  }

  tag {
    key                 = "Name"
    value               = "${var.prefix}-github-actions-runner"
    propagate_at_launch = true
  }

  dynamic "tag" {
    for_each = var.tags
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [desired_capacity]
  }
}

# ─── ASG Scaling Policies ─────────────────────────────────────────────────────

resource "aws_autoscaling_policy" "scale_out" {
  name                   = "${var.prefix}-github-runner-scale-out"
  autoscaling_group_name = aws_autoscaling_group.runner.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = 1
  cooldown               = 300
}

resource "aws_autoscaling_policy" "scale_in" {
  name                   = "${var.prefix}-github-runner-scale-in"
  autoscaling_group_name = aws_autoscaling_group.runner.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = -1
  cooldown               = 300
}

# ─── CloudWatch Alarms ────────────────────────────────────────────────────────

resource "aws_cloudwatch_metric_alarm" "cpu_high" {
  alarm_name          = "${var.prefix}-github-runner-cpu-high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = var.scale_out_cpu_threshold

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.runner.name
  }

  alarm_description = "Scale out when average CPU >= ${var.scale_out_cpu_threshold}%"
  alarm_actions     = [aws_autoscaling_policy.scale_out.arn]
  tags              = var.tags
}

resource "aws_cloudwatch_metric_alarm" "cpu_low" {
  alarm_name          = "${var.prefix}-github-runner-cpu-low"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = var.scale_in_cpu_threshold

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.runner.name
  }

  alarm_description = "Scale in when average CPU <= ${var.scale_in_cpu_threshold}%"
  alarm_actions     = [aws_autoscaling_policy.scale_in.arn]
  tags              = var.tags
}
