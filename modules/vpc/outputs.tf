#-----VPC Outputs-----------------
output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.this.id
}
output "vpc_cidr_block" {   
  description = "The CIDR block of the VPC"
  value       = aws_vpc.this.cidr_block
}
output "vpc_arn" {   
  description = "The ARN of the VPC"
  value       = aws_vpc.this.arn
}

#------------Public Subnets Outputs-----------------
output "public_subnet_ids" {
    description = "List of IDs of the public subnets"
    value       = aws_subnet.public[*].id
}
#------------Private Subnets Outputs-----------------
output "private_subnet_ids" {
    description = "List of IDs of the private subnets"
    value       = aws_subnet.private[*].id
}   
#------------NAT Gateway Outputs-----------------
output "nat_gateway_ids" {
    description = "List of IDs of the NAT gateways"
    value       = aws_nat_gateway.this[*].id
}   
#------------Internet Gateway Outputs-----------------
output "internet_gateway_id" {
    description = "ID of the Internet Gateway"
    value       = aws_internet_gateway.this.id
}   
#------------Nat Gateway EIP Public IPs Outputs-----------------
output "nat_gateway_eip_public_ips" {
    description = "List of public IPs of the NAT gateways"
    value       = aws_eip.nat[*].public_ip
}
#------------Availability Zones Outputs-----------------
output "availability_zones" {
    description = "List of availability zones used for subnets"
    value       = var.availability_zones
}

#------------Route Table Outputs-----------------
output "public_route_table_id" {
    description = "ID of the public route table"
    value       = aws_route_table.public.id
}

output "private_route_table_ids" {
    description = "List of IDs of the private route tables"
    value       = aws_route_table.private[*].id
}
