data "aws_subnet" "subnets" {
  count = length(var.public_subnets)
  id = element(var.public_subnets, count.index)
}

resource "aws_autoscaling_group" "ecs-asg" {
  name = "ecs-asg"
  max_size = 3
  min_size = 1
  desired_capacity = 2
  vpc_zone_identifier = local.subnet_ids
  launch_template {
    id      = aws_launch_template.ecs_ec2_lt.id
    version = "$Latest"
  }
  tag {
    key                 = "AmazonECSManaged"
    value               = true
    propagate_at_launch = true
  }
}