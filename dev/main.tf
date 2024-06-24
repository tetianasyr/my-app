module "vpc" {
  source = "../modules/networking"

  region = var.region
  environment = var.environment

  for_each = var.vpc_config

  vpc_cidr = each.value.vpc_cidr
  public_subnet_count = each.value.public_subnet_count
  private_subnet_count = each.value.private_subnet_count
}

module "ec2" {
  source = "../modules/ec2"

  for_each = var.vpc_config

  public_subnets = module.vpc[each.key].public_subnets
  private_subnets = module.vpc[each.key].private_subnets
  environment = var.environment
  ec2_instance_type = var.ec2_instance_type
}