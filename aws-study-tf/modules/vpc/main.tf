
#vpc
resource "aws_vpc" "awsstudytfvpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.prefix}-vpc"
  }
}

resource "aws_internet_gateway" "awsstudytfigw" {
  vpc_id = aws_vpc.awsstudytfvpc.id
  tags = {
    Name = "${var.prefix}-igw"
  }
}

resource "aws_route_table" "awsstudytfpublicrtb" {
  vpc_id = aws_vpc.awsstudytfvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.awsstudytfigw.id
  }

  tags = {
    Name = "${var.prefix}-public-rtb"
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_subnet" "awsstudytfpublicsubnet" {
  count                   = 2
  vpc_id                  = aws_vpc.awsstudytfvpc.id
  cidr_block              = cidrsubnet("10.0.0.0/20", 4, count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.prefix}-public-subnet-${count.index + 1}"
  }
}

resource "aws_route_table_association" "public_association" {
  count          = 2
  subnet_id      = aws_subnet.awsstudytfpublicsubnet[count.index].id
  route_table_id = aws_route_table.awsstudytfpublicrtb.id
}

resource "aws_route_table" "awsstudytfprivatertb" {
  count  = 2
  vpc_id = aws_vpc.awsstudytfvpc.id

  # route {
  #   cidr_block = cidrsubnet("10.0.16.0/20", 4, count.index)
  #   #gateway_id = "local"
  # }

  tags = {
    Name = "${var.prefix}-private-rtb-${count.index + 1}"
  }
}


resource "aws_subnet" "awsstudytfprivatesubnet" {
  count                   = 2
  vpc_id                  = aws_vpc.awsstudytfvpc.id
  cidr_block              = cidrsubnet("10.0.16.0/20", 4, count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.prefix}-private-subnet-${count.index + 1}"
  }
}

resource "aws_route_table_association" "private_association" {
  count          = 2
  subnet_id      = aws_subnet.awsstudytfprivatesubnet[count.index].id
  route_table_id = aws_route_table.awsstudytfprivatertb[count.index].id
}

