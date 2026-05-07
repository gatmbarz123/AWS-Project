output "endpoint" {
  value = aws_rds_cluster.aurora_db.endpoint
}

output "address" {
  value = "${aws_rds_cluster.aurora_db.endpoint}:${var.rds_port}"
}
output "port" {
  value = var.rds_port
}
output "master_username" {
  value = var.master_username
}