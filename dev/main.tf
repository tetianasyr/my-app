module "vpc" {
  source = "../modules/networking"

  region = var.region
  environment = var.environment

  for_each = var.vpc_config

  vpc_cidr = each.value.vpc_cidr
  public_subnet_count = each.value.public_subnet_count
  private_subnet_count = each.value.private_subnet_count
}

# module "ec2" {
#   source = "../modules/ec2"
#
#   for_each = var.vpc_config
#
#   vpc_id              = module.vpc[each.key].vpc_id
#   vpc_cidr_block      = module.vpc[each.key].vpc_cidr_block
#   public_subnets      = module.vpc[each.key].public_subnets
#   private_subnets     = module.vpc[each.key].private_subnets
#   environment         = var.environment
#   ec2_instance_type   = var.ec2_instance_type
#   iam_instance_profile_ec2 = module.ecs.iam_instance_profile_ec2
#   ssh_public_key      = var.ssh_public_key
#
#   depends_on = [module.ecs, module.vpc]
# }

module "ecs" {
#   source = "../modules/ecs"
  source = "../modules/ecs-ec2"

  for_each = var.vpc_config

  app_name             = var.app_name
  environment          = var.environment
  app_image            = var.app_image
  region               = var.region
  vpc_id               = module.vpc[each.key].vpc_id
  vpc_cidr_block       = module.vpc[each.key].vpc_cidr_block
  private_subnets      = module.vpc[each.key].private_subnets
  public_subnets       = module.vpc[each.key].public_subnets
  ssh_public_key       = var.ssh_public_key
  ec2_instance_type   = var.ec2_instance_type
}