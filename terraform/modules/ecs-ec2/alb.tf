data "aws_subnet" "public_subnets" {
  count = length(var.public_subnets)
  id = element(var.public_subnets, count.index)
}

resource "aws_lb" "ecs_alb" {
  name               = format("ecs-alb-%s", var.environment)
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = local.public_subnet_ids

  tags = {
    Name = format("ecs-alb-%s",var.environment)
  }
}

resource "aws_lb_target_group" "ecs_tg" {
  name        = format("ecs-target-group-%s", var.environment)
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id

  health_check {
    path = "/"
  }
}

resource "aws_lb_listener" "ecs_alb_listener" {
  load_balancer_arn = aws_lb.ecs_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs_tg.arn
  }
}

resource "aws_security_group" "alb_sg" {
  name        = format("alb-sg-%s", var.environment)
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}