locals {
  subnet_ids = [for subnet in data.aws_subnet.subnets : subnet.id]
}