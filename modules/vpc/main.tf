resource "aws_vpc" "this" {
  cidr_block = var.cidr_block
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "${var.name}-vpc"
  }
}

#------------Public Subnets-----------------
 resource "aws_subnet" "public" {
    count = length(var.public_subnet_cidrs)
    vpc_id = aws_vpc.this.id
    cidr_block = var.public_subnet_cidrs[count.index]
    availability_zone = var.availability_zones[count.index]
    map_public_ip_on_launch = true  # ADDED: Auto-assign public IPs
    tags = {
      Name = "${var.name}-public-subnet-${count.index + 1}"
      Type = "Public"
    }
    depends_on = [ aws_vpc.this ]
   
 }

 #------------Private Subnets-----------------
 resource "aws_subnet" "private" {
    count = length(var.private_subnet_cidrs)
    vpc_id = aws_vpc.this.id
    cidr_block = var.private_subnet_cidrs[count.index]
    availability_zone = var.availability_zones[count.index]
    tags = {
      Name = "${var.name}-private-subnet-${count.index + 1}"
      Type = "Private"
    }
    depends_on = [ aws_vpc.this ]
 }

 #------------Internet Gateway-----------------
  resource "aws_internet_gateway" "this" {
    vpc_id = aws_vpc.this.id
    tags = {
      Name = "${var.name}-igw"
    }
    depends_on = [ aws_vpc.this ]
 }  

 #------------Elastic IP for NAT Gateway-----------------
  resource "aws_eip" "nat" {
    count = var.enable_single_nat_gateway ? 1 : length(var.public_subnet_cidrs)
    domain = "vpc"

  tags = {
    Name = var.enable_single_nat_gateway ? "${var.name}-nat-eip" : "${var.name}-nat-eip-${count.index + 1}"
  }
    depends_on = [ aws_internet_gateway.this ]

 }

#------------NAT Gateway-----------------
  resource "aws_nat_gateway" "this" {
    count = var.enable_single_nat_gateway ? 1 : length(var.public_subnet_cidrs)
    allocation_id = aws_eip.nat[count.index].id
    subnet_id = var.enable_single_nat_gateway ? aws_subnet.public[0].id : aws_subnet.public[count.index].id
    tags = {
      Name = var.enable_single_nat_gateway ? "${var.name}-nat-gateway" : "${var.name}-nat-gateway-${count.index + 1}"
    }
    depends_on = [ aws_eip.nat ]
 }
 #------------Route Table for Public Subnets-----------------
  resource "aws_route_table" "public" {
    vpc_id = aws_vpc.this.id
    tags = {
      Name = "${var.name}-public-rt"
    }
    depends_on = [ aws_internet_gateway.this, aws_subnet.public ]
 }
#---Routes for Public Subnets
  resource "aws_route" "public_internet_access" {
    route_table_id = aws_route_table.public.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
    depends_on = [ aws_route_table.public ]
 }

  resource "aws_route_table_association" "public" {
    count = length(var.public_subnet_cidrs)
    subnet_id = aws_subnet.public[count.index].id
    route_table_id = aws_route_table.public.id
    depends_on = [ aws_route_table.public, aws_subnet.public ]
 }

 #------------Route Table for Private Subnets-----------------
  resource "aws_route_table" "private" {
    count = var.enable_single_nat_gateway ? 1 : length(var.private_subnet_cidrs)
    vpc_id = aws_vpc.this.id
    tags = {
      Name = var.enable_single_nat_gateway ? "${var.name}-private-rt" : "${var.name}-private-rt-${count.index + 1}"
    }
 }
#---Routes for Private Subnets
  resource "aws_route" "private_internet_access" {
    count = var.enable_single_nat_gateway ? 1 : length(var.private_subnet_cidrs)
    route_table_id = var.enable_single_nat_gateway ? aws_route_table.private[0].id : aws_route_table.private[count.index].id
    destination_cidr_block = "0.0.0.0/0"
    nat_gateway_id = var.enable_single_nat_gateway ? aws_nat_gateway.this[0].id : aws_nat_gateway.this[count.index].id
 }

  resource "aws_route_table_association" "private" {
    count = length(var.private_subnet_cidrs)
    subnet_id = aws_subnet.private[count.index].id
    route_table_id = var.enable_single_nat_gateway ? aws_route_table.private[0].id : aws_route_table.private[count.index].id
 }

#------------VPC End-----------------