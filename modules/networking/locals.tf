locals {
  region = var.region
  azs    = slice(data.aws_availability_zones.available.names, 0, 2)
}