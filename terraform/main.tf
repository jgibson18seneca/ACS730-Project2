provider "aws" {
  region = "us-east-1"
}

# use data source to get all avalablility zones in region
data "aws_availability_zones" "available" {}

# create prod vpc
resource "aws_vpc" "prod" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default" 
  enable_dns_hostnames = true

  tags = {
    Name = "VPC-Prod"
  }
}

# create internet gateway and attach it to vpc
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.prod.id

  tags = {
    Name = "${var.prefix}-igw"
  }
}

# create Non-public public subnet
resource "aws_subnet" "prod_public_subnet" {
  count                   = length(var.public_cidrs)
  vpc_id                  = aws_vpc.prod.id
  cidr_block              = var.public_cidrs[count.index]
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "Public_subnet${count.index + 1}"
  }
}

# create Non-public public subnet
resource "aws_subnet" "prod_private_subnet" {
  count                   = length(var.private_cidrs)
  vpc_id                  = aws_vpc.prod.id
  cidr_block              = var.private_cidrs[count.index]
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = false

  tags = {
    Name = "Private_subnet${count.index + 1}"
  }
}

# create route table and add public route
resource "aws_route_table" "prod_public_rt" {
  vpc_id = aws_vpc.prod.id

  route {    
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags = {
    Name = "Public-rt"
  }
}

# associate non-prod public subnet to "public route table"
resource "aws_route_table_association" "prod_public_subnet_rt_association" {
  count          = length(var.public_cidrs)
  subnet_id      = aws_subnet.prod_public_subnet[count.index].id
  route_table_id = aws_route_table.prod_public_rt.id
}

# create route table for private subnets
resource "aws_route_table" "prod_private_rt" {
  vpc_id = aws_vpc.prod.id
  
  route {    
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gateway.id
  }

  tags = {
    Name = "Private-rt"
  }
}

# associate private subnet az1 to "private route table"
resource "aws_route_table_association" "public_subnet_rt_association" {
  count          = length(var.private_cidrs)
  subnet_id      = aws_subnet.prod_private_subnet[count.index].id
  route_table_id = aws_route_table.prod_private_rt.id
}

#Creating nat gateway in public subnet 1
resource "aws_nat_gateway" "nat_gateway" {
  connectivity_type = "private"
  subnet_id     = aws_subnet.prod_public_subnet[0].id

  tags = {
    Name = "${var.prefix}-ngw"
  }
}