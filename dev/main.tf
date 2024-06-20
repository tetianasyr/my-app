module "vpc" {
  source = "../modules/networking"

  region = var.region
  environment = var.environment

  for_each = var.vpc_config

  vpc_cidr = each.value.vpc_cidr
  public_subnet_count = each.value.public_subnet_count
  private_subnet_count = each.value.private_subnet_count
}