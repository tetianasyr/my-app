data "aws_availability_zones" "available" {}

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = format("vpc-%s", var.environment)
  }
}

resource "aws_subnet" "public" {
  count = var.public_subnet_count < length(data.aws_availability_zones.available) ? var.public_subnet_count : length(data.aws_availability_zones.available)

  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = format("public-%s-%s-%s", var.environment, count.index, data.aws_availability_zones.available.names[count.index])
  }
}

resource "aws_subnet" "private" {
  count = var.private_subnet_count < length(data.aws_availability_zones.available) ? var.private_subnet_count : length(data.aws_availability_zones.available)

  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, count.index + var.public_subnet_count)
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = format("private-%s-%s-%s", var.environment, count.index, data.aws_availability_zones.available.names[count.index])
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = format("main-gw-%s", var.environment)
  }
}

resource "aws_nat_gateway" "ngw" {
  count = var.private_subnet_count
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  tags = {
    Name = format("nat-gw-%s-%s", var.environment, count.index)
  }

  depends_on = [aws_internet_gateway.igw]
}
resource "aws_eip" "nat" {
  count = var.private_subnet_count
  domain = "vpc"

  tags = {
    Name = format("nat-eip-%s-%s", var.environment, count.index)
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = format("public-route-table-%s", var.environment)
  }
}


resource "aws_route_table_association" "public" {
  count          = var.public_subnet_count
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  count = var.private_subnet_count
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ngw[count.index].id
  }

  tags = {
    Name = format("private-route-table-%s-%s", var.environment, count.index)
  }
}

resource "aws_route_table_association" "private" {
  count = var.private_subnet_count
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}