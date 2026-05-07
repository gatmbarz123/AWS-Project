data "aws_vpc" "vpc" {
  filter {
    name = "tag:Name"
    values = [
      "${var.prefix}-vpc"
    ]
  }
}

data "aws_subnets" "private_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.vpc.id]
  }
  tags = {
    Tier = "private"
  }
}