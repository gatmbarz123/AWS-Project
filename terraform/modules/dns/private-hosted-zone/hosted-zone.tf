resource "aws_route53_zone" "private" {
  name = var.name
  vpc {
    vpc_id = var.vpc_id
  }

  tags = var.tags

  # NOTE: The aws_route53_zone vpc argument accepts multiple configuration
  #       blocks. The below usage of the single vpc configuration, the
  #       lifecycle configuration, and the aws_route53_zone_association
  #       resource is for illustrative purposes (e.g., for a separate
  #       cross-account authorization process, which is not shown here).
  lifecycle {
    ignore_changes = [vpc]
  }
}