locals {
  name   = var.vpc_name
  region = var.aws_region
  azs    = slice(data.aws_availability_zones.available.names, 0, 2)
}