# Create VPC
resource "aws_vpc" "main" {
  cidr_block = var.cidr_block
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = {
    Name = var.core_name
    ManagedBy = "Terraform"
  }
}

resource "aws_internet_gateway" "primary" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.core_name}-igw"
    ManagedBy = "Terraform"
  }
}

resource "aws_subnet" "public" {
  count = length(var.availability_zones)
  vpc_id = aws_vpc.main.id
  cidr_block = var.public_subnets[count.index]
  availability_zone = var.availability_zones[count.index]
  tags = {
    Name = format("${var.core_name}-public-%s", element(var.availability_zones, count.index))
    ManagedBy = "Terraform"
  }
}

resource "aws_subnet" "private" {
  count = length(var.availability_zones)
  vpc_id = aws_vpc.main.id
  cidr_block = var.private_subnets[count.index]
  availability_zone = var.availability_zones[count.index]
  tags = {
    Name = format("${var.core_name}-public-%s", element(var.availability_zones, count.index))
    ManagedBy = "Terraform"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.core_name}-public-rtb"
    ManagedBy = "Terraform"
  }
}

resource "aws_route_table_association" "public" {
  count = length(var.public_subnets)
  route_table_id = aws_route_table.public.id
  subnet_id = aws_subnet.public[count.index].id
}

resource "aws_route" "public_igw" {
  route_table_id = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.primary.id
}
