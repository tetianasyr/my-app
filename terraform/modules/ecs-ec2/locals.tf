locals {
  public_subnet_ids = [for subnet in data.aws_subnet.public_subnets : subnet.id]
  private_subnet_ids = [for subnet in data.aws_subnet.private_subnets : subnet.id]

  app_name = format("my-pet-app-new-%s", var.environment)
  app_image = format("637423170103.dkr.ecr.us-east-1.amazonaws.com/my-pet-app-new:%s", var.build_version)
  ecs_cluster_name = format("myapp-cluster-new-%s", var.environment)
}