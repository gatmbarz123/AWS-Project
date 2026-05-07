data "aws_route53_zone" "private" {
  name         = var.private_hosted_zone_name
  private_zone = true
}

data "aws_eks_cluster" "web" {
  name = "${var.prefix}-web-eks"
}

data "aws_partition" "current" {}