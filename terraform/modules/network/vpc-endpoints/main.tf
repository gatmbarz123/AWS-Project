resource "aws_vpc_endpoint" "vpce" {
  vpc_id              = var.vpc_id
  subnet_ids          = var.vpc_endpoint_type == "Gateway" ? null : var.subnet_ids
  route_table_ids     = var.vpc_endpoint_type == "Gateway" ? var.route_table_ids : null
  auto_accept         = true
  service_name        = var.service_name
  ip_address_type     = var.ip_address_type
  vpc_endpoint_type   = var.vpc_endpoint_type
  security_group_ids  = var.vpc_endpoint_type == "Gateway" ? null : [aws_security_group.vpce.id]
  private_dns_enabled = var.private_dns_enabled
  dns_options {
    private_dns_only_for_inbound_resolver_endpoint = var.private_dns_only_for_inbound_resolver_endpoint
  }
  tags = {
    Name = "${var.prefix}-vpce-${var.name}"
  }
}

# Security group for VPC Endpoint
resource "aws_security_group" "vpce" {
  name        = "${var.prefix}-vpce-${var.name}"
  vpc_id      = var.vpc_id
  description = "Access to vpc endpoint vpce to ${var.service_name}"
  tags        = merge(var.tags, { Name = "${var.prefix}-vpce" })
}

# Inbound-rule for the security group
resource "aws_security_group_rule" "ingress" {
  security_group_id = aws_security_group.vpce.id
  type              = "ingress"
  for_each          = var.sg_ingress_rules
  from_port         = lookup(each.value, "from_port", 443)
  to_port           = lookup(each.value, "to_port", 443)
  protocol          = lookup(each.value, "protocol", "tcp")
  description       = "Access to vpc endpoint vpce to ${var.service_name}"
  cidr_blocks       = lookup(each.value, "cidr_blocks", [var.vpc_cidr_block])
}

# outbound-rule for the security group
resource "aws_security_group_rule" "egress" {
  security_group_id = aws_security_group.vpce.id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}
