module "rds" {
  source = "../../../../modules/database/rds-aurora"

  prefix               = var.prefix
  vpc_id               = data.aws_vpc.vpc.id
  vpc_cidr_block       = data.aws_vpc.vpc.cidr_block
  db_subnet_group_name = data.aws_db_subnet_group.db_subnet_group.name

  for_each = var.rds_aurora

  name                                = each.key
  engine                              = lookup(each.value, "engine", "aurora-postgresql")
  engine_version                      = lookup(each.value, "engine_version", null)
  ca_cert_identifier                  = lookup(each.value, "ca_cert_identifier", "rds-ca-rsa2048-g1")
  database_name                       = lookup(each.value, "database_name", null)
  rds_port                            = lookup(each.value, "rds_port", 5432)
  azs                                 = lookup(each.value, "azs", null)
  master_username                     = lookup(each.value, "master_username", null)
  backup_retention_period             = lookup(each.value, "backup_retention_period", 7)
  deletion_protection                 = lookup(each.value, "deletion_protection", true)
  preferred_backup_window             = lookup(each.value, "preferred_backup_window", "00:00-01:00")
  skip_final_snapshot                 = lookup(each.value, "skip_final_snapshot", false)
  iam_database_authentication_enabled = lookup(each.value, "iam_database_authentication_enabled", false)
  enabled_cloudwatch_logs_exports     = lookup(each.value, "enabled_cloudwatch_logs_exports", ["postgresql"])
  instance_count                      = lookup(each.value, "instance_count", 1)
  instance_az                         = lookup(each.value, "instance_az", null)
  monitoring_interval                 = lookup(each.value, "monitoring_interval", 0)
  allow_major_version_upgrade         = lookup(each.value, "allow_major_version_upgrade", false)
  secret_rotation_schedule            = lookup(each.value, "secret_rotation_schedule", null)

  tags = var.tags
}
