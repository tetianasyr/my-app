module "vpc" {
  source = "../modules/networking"

  environment = var.environment

  for_each = var.vpc_config

  vpc_cidr = each.value.vpc_cidr
  public_subnet = each.value.public_subnet
  private_subnet = each.value.private_subnet
}