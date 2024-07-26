locals {
  region = var.region
  public_subnet_ids = [for subnet in data.aws_subnet.public_subnets : subnet.id]
  private_subnet_ids = [for subnet in data.aws_subnet.private_subnets : subnet.id]

  ecs_cluster_name = var.ecs_cluster_name
  environment = var.environment
  ec2_instance_type = var.ec2_instance_type
  app_name = var.app_name
  app_image = var.app_name
}