resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${local.ecs_cluster_name}"
}

resource "aws_ecs_capacity_provider" "ecs_capacity_provider" {
  name = "test_app_capacity_provider"

  auto_scaling_group_provider {
    auto_scaling_group_arn = aws_autoscaling_group.ecs-asg.arn

    managed_scaling {
      maximum_scaling_step_size = 1000
      minimum_scaling_step_size = 1
      status                    = "ENABLED"
      target_capacity           = 3
    }
  }
}

resource "aws_ecs_cluster_capacity_providers" "ecs_ccp" {
  cluster_name = aws_ecs_cluster.ecs_cluster.name

  capacity_providers = [aws_ecs_capacity_provider.ecs_capacity_provider.name]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = aws_ecs_capacity_provider.ecs_capacity_provider.name
  }
}

data "template_file" "my_app" {
  template = file("${path.module}/tdt_app.json.tpl")

  vars = {
    app_image = local.app_image
    app_port = 80
    cpu = "10"
    aws_region = local.region
    env = local.environment
    app_name = local.app_name
  }
}

resource "aws_ecs_task_definition" "myapp_task" {
  family                   = "${var.app_name}-${var.environment}-task"
  network_mode             = "awsvpc"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  cpu                      = 1024
  memory                   = 2048
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }
  container_definitions = data.template_file.my_app.rendered
  requires_compatibilities = ["EC2","FARGATE"]
}

resource "aws_ecs_service" "main" {
  name            = "${var.app_name}-${var.environment}-service"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.myapp_task.arn
  desired_count   = 1

  network_configuration {
    subnets         = var.private_subnets
    security_groups = [aws_security_group.ecs_sg.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.ecs_tg.arn
    container_name   = local.app_name
    container_port   = 80
  }

  force_new_deployment = true
  placement_constraints {
    type = "distinctInstance"
  }

  capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.ecs_capacity_provider.name
    weight            = 100
  }
  depends_on = [aws_lb_listener.ecs_alb_listener, aws_autoscaling_group.ecs-asg]
}

resource "aws_security_group" "ecs_sg" {
  name        = "ecs-sg"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}