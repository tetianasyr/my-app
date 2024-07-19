data "aws_ami" "amazon_linux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
  owners      = ["amazon"]
}

resource "aws_key_pair" "ec2" {
  key_name = format("%s-ec2-key", var.environment)
  public_key = var.ssh_public_key
}

resource "aws_launch_template" "ecs_ec2_lt" {
  name_prefix = "ecs-template"
  block_device_mappings {
    device_name = "/dev/sdf"

    ebs {
      volume_size = 30
    }
  }

  image_id      = data.aws_ami.amazon_linux.id
  instance_type = var.ec2_instance_type
  key_name      = aws_key_pair.ec2.key_name
  iam_instance_profile {
    name = aws_iam_instance_profile.ecs_ec2_profile.name
  }
  vpc_security_group_ids = [aws_security_group.ecs_sg.id]

  user_data = filebase64("${path.module}/ecs.sh")

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "ecs-instance"
    }
  }
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
