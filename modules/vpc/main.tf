resource "aws_vpc" "main" {
  cidr_block           = var.cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "${var.env}-vpc"
  } 
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.env}-igw"
  }
  
}

resource "aws_subnet" "public" {
  count = 2 # Number of public subnets
  vpc_id = aws_vpc.main.id        
  cidr_block = cidrsubnet(var.cidr_block, 8, count.index)
  map_public_ip_on_launch = true
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = {
    Name = "${var.env}-public-subnet-${count.index+1}"
  }
}

resource "aws_subnet" "private" {
  count = 2 # Number of private subnets
  vpc_id = aws_vpc.main.id        
  cidr_block = cidrsubnet(var.cidr_block, 8, count.index + 10)
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = {
    Name = "${var.env}-private-subnet-${count.index+1}"
  }
  
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  } 
  tags = {
    Name = "${var.env}-public-route-table"
  }
}

resource "aws_route_table_association" "public" {
  count = 2 # Number of public subnets
  subnet_id = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
  
}
data "aws_availability_zones" "available" {}
