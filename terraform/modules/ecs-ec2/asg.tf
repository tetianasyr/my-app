data "aws_subnet" "private_subnets" {
  count = length(var.private_subnets)
  id = element(var.private_subnets, count.index)
}

resource "aws_autoscaling_group" "ecs-asg" {
  name = format("ecs-asg-%s", var.environment)
  max_size = var.max_app_count
  min_size = var.min_app_count
  desired_capacity = var.app_count
  vpc_zone_identifier = local.private_subnet_ids
  launch_template {
    id      = aws_launch_template.ecs_ec2_lt.id
    version = "$Latest"
  }
  tag {
    key                 = "AmazonECSManaged"
    value               = "ecs-instance"
    propagate_at_launch = true
  }
}