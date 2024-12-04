resource "aws_ecs_cluster" "ecs_cluster" {
  name = "ecs-cluster-${var.app_name}-${var.environment}"
}

data "template_file" "my_app" {
  template = file("${path.module}/tdt_app.json.tpl")

  vars = {
    app_image = var.app_image
    app_port = 80
    fargate_cpu = "10"
    aws_region = var.region
    env = var.environment
    app_name = var.app_name
  }
}

resource "aws_security_group" "ecs_service_sg" {
  name        = "ecs-service-sg"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_ecs_task_definition" "myapp_task" {
  family                   = "${var.app_name}-${var.environment}-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 1024
  memory                   = 2048

  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = data.template_file.my_app.rendered
}

resource "aws_ecs_service" "main" {
  name            = "${var.app_name}-${var.environment}-service"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.myapp_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = var.private_subnets
    security_groups = [aws_security_group.ecs_service_sg.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.ecs_tg.arn
    container_name   = var.app_name
    container_port   = 80
  }
  depends_on = [aws_lb_listener.ecs_alb_listener]
}