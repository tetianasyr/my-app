data "aws_ami" "amazon_ecs_linux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-ecs-hvm-2.*-x86_64-ebs"]
  }
  owners      = ["amazon"]
}

resource "aws_key_pair" "ec2" {
  key_name = format("%s-ec2-key", local.environment)
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

  image_id      = data.aws_ami.amazon_ecs_linux.id
  instance_type = local.ec2_instance_type
  key_name      = aws_key_pair.ec2.key_name
  iam_instance_profile {
    name = aws_iam_instance_profile.ecs_ec2_profile.name
  }
  user_data = base64encode(templatefile("${path.module}/ecs.sh", {ecs_cluster_name=local.ecs_cluster_name}))

  network_interfaces {
    associate_public_ip_address = false
    security_groups = [aws_security_group.ecs_node_sg.id]
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "ecs-instance"
    }
  }

  depends_on = [aws_ecs_cluster.ecs_cluster]
}

resource "aws_security_group" "ecs_node_sg" {
  name_prefix = "ecs-node-sg"
  vpc_id      = var.vpc_id

  ingress {
    description     = "Allow ingress traffic from ALB on HTTP on ephemeral ports"
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "public" {
  ami             = data.aws_ami.amazon_linux.id
  instance_type   = local.ec2_instance_type
  key_name        = aws_key_pair.ec2.key_name
  iam_instance_profile = aws_iam_instance_profile.ecs_ec2_profile.name
  subnet_id       = local.public_subnet_ids[0]
  vpc_security_group_ids = [aws_security_group.public.id]
  associate_public_ip_address = true

  tags = {
    Name = format("public-instance-%s", var.environment)
  }
}

data "aws_ami" "amazon_linux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
  owners      = ["amazon"]
}

resource "aws_security_group" "public" {
  name        = format("%s-public-allow_tls", var.environment)
  description = "Allow TLS traffic for public instances"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = format("%s-public-sg", var.environment)
  }
}