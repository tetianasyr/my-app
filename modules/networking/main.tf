data "aws_availability_zones" "available" {}

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "vpc-${var.environment}"
  }
}

resource "aws_subnet" "public" {
  count = length(var.public_subnet)

  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnet[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "public-subnet-${var.environment}"
  }
}

resource "aws_subnet" "private" {
  count = length(var.private_subnet)

  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "private-subnet-${var.environment}-${count.index}"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main-gw-${var.environment}"
  }
}

resource "aws_nat_gateway" "ngw" {
  count = length(var.private_subnet)
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  tags = {
    Name = "nat-gw-${var.environment}"
  }

  depends_on = [aws_internet_gateway.igw]
}
resource "aws_eip" "nat" {
  count = length(var.private_subnet)
  domain = "vpc"

  tags = {
    Name = "nat-eip-${var.environment}"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public-route-table-${var.environment}"
  }
}


resource "aws_route_table_association" "public" {
  count          = length(var.public_subnet)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  count = length(var.private_subnet)
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ngw[count.index].id
  }

  tags = {
    Name = "private-route-table-${var.environment}"
  }
}

resource "aws_route_table_association" "private" {
  count = length(var.private_subnet)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}