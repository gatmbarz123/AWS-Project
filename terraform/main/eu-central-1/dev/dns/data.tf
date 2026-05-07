data "aws_vpc" "vpc" {
  filter {
    name = "tag:Name"
    values = [
      "${var.prefix}-vpc"
    ]
  }
}

data "aws_vpc" "vpc_windows" {
  filter {
    name = "tag:Name"
    values = [
      "${var.prefix}-vpc-windows"
    ]
  }
}
