data "aws_ami" "amazon_linux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
  owners      = ["amazon"]
}

resource "aws_instance" "public" {
  count         = length(var.public_subnets)
  ami           = data.aws_ami.amazon_linux.id
  instance_type = var.ec2_instance_type
  subnet_id     = element(var.public_subnets, count.index)

  tags = {
    Name = format("public-instance-%s-%s", var.environment, count.index)
  }
}

resource "aws_instance" "private" {
  count         = length(var.private_subnets)
  ami           = data.aws_ami.amazon_linux.id
  instance_type = var.ec2_instance_type
  subnet_id     = element(var.private_subnets, count.index)

  tags = {
    Name = format("private-instance-%s-%s", var.environment, count.index)
  }
}