# Security Group for Aurora - RDS 
resource "aws_security_group" "rds" {
  name        = "${var.prefix}-${var.name}-cluster-sg"
  vpc_id      = var.vpc_id
  description = "Access to rds ${var.prefix}-${var.name}-cluster"
  tags        = merge(var.tags, { Name = "${var.prefix}-${var.name}-cluster-sg" })
}

# Inbound-rule for the security group
resource "aws_security_group_rule" "rds" {
  security_group_id = aws_security_group.rds.id
  type              = "ingress"
  from_port         = var.rds_port
  to_port           = var.rds_port
  protocol          = "tcp"
  description       = "${var.engine} access from within VPC"
  cidr_blocks       = [var.vpc_cidr_block]
}

# outbound-rule for the security group
resource "aws_security_group_rule" "egress_rds" {
  security_group_id = aws_security_group.rds.id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

###################
# Aurora RDS
###################
resource "aws_rds_cluster" "aurora_db" {
  cluster_identifier          = "${var.prefix}-${var.name}-rds-cluster"
  engine                      = var.engine
  engine_version              = var.engine_version
  engine_mode                 = "provisioned"
  availability_zones          = var.azs
  db_subnet_group_name        = var.db_subnet_group_name
  database_name               = var.database_name
  master_username             = var.master_username
  manage_master_user_password = true
  backup_retention_period     = var.backup_retention_period
  deletion_protection         = var.deletion_protection
  preferred_backup_window     = var.preferred_backup_window
  skip_final_snapshot         = var.skip_final_snapshot
  final_snapshot_identifier   = var.skip_final_snapshot == false ? "${var.prefix}-final-snapshot-${formatdate("YYYYMMDDhhmmss", timestamp())}" : null
  storage_encrypted           = true

  iam_database_authentication_enabled = var.iam_database_authentication_enabled

  enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports != [] ? var.enabled_cloudwatch_logs_exports : []
  vpc_security_group_ids = [
    aws_security_group.rds.id
  ]

  # Serverless v2 scaling configuration (only for serverless mode)
  # Note: Aurora Serverless v2 is NOT supported in AWS GovCloud
  dynamic "serverlessv2_scaling_configuration" {
    for_each = var.use_serverless ? [1] : []
    content {
      max_capacity = 30
      min_capacity = 0.5
    }
  }

  # Aurora DB Cluster

  allow_major_version_upgrade = var.allow_major_version_upgrade
  apply_immediately           = false

  tags = var.tags

  lifecycle {
    ignore_changes = [
      final_snapshot_identifier
    ]
  }
}

resource "aws_rds_cluster_instance" "db_instance" {
  count = var.instance_count

  identifier          = "${var.prefix}-${var.name}-rds-instance-${count.index}"
  cluster_identifier  = aws_rds_cluster.aurora_db.id
  instance_class      = var.instance_class # Uses db.serverless or provisioned class
  engine              = aws_rds_cluster.aurora_db.engine
  engine_version      = aws_rds_cluster.aurora_db.engine_version
  availability_zone   = var.instance_az
  publicly_accessible = false
  monitoring_interval = var.monitoring_interval
  ca_cert_identifier  = var.ca_cert_identifier

  apply_immediately = false

  tags = var.tags
}

###################
# Secret Rotation
###################

resource "aws_secretsmanager_secret_rotation" "rds_secret_rotation" {
  count     = var.secret_rotation_schedule != null ? 1 : 0
  secret_id = aws_rds_cluster.aurora_db.master_user_secret[0].secret_arn

  rotation_rules {
    schedule_expression = var.secret_rotation_schedule
  }
}
