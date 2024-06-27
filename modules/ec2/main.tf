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

resource "aws_instance" "public" {
  count           = length(var.public_subnets)
  ami             = data.aws_ami.amazon_linux.id
  instance_type   = var.ec2_instance_type
  key_name        = aws_key_pair.ec2.key_name
  iam_instance_profile = var.iam_instance_profile
  subnet_id       = element(var.public_subnets, count.index)
  vpc_security_group_ids = [aws_security_group.public.id]
  associate_public_ip_address = true

  tags = {
    Name = format("public-instance-%s-%s", var.environment, count.index)
  }
}

resource "aws_instance" "private" {
  count         = length(var.private_subnets)
  ami           = data.aws_ami.amazon_linux.id
  instance_type = var.ec2_instance_type
  key_name        = aws_key_pair.ec2.key_name
  iam_instance_profile = var.iam_instance_profile
  subnet_id     = element(var.private_subnets, count.index)
  vpc_security_group_ids = [aws_security_group.public.id]

  tags = {
    Name = format("private-instance-%s-%s", var.environment, count.index)
  }
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
# resource "aws_security_group" "private" {
#   name        = format("%s-private-allow-tls", var.environment)
#   description = "Security group for private instances"
#   vpc_id      = var.vpc_id
#
#   ingress {
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     cidr_blocks = [var.vpc_cidr_block]
#   }
#
#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#
#   tags = {
#     Name        = format("%s-private-sg", var.environment)
#   }
# }