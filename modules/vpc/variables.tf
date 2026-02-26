variable "name" {
    description = "Name prefix for resources"
    type = string
}

variable "cidr_block" {    
    description = "CIDR block for the VPC"
    type = string
}

variable "public_subnet_cidrs" {
    description = "List of CIDR blocks for public subnets"
    type = list(string)
}

variable "private_subnet_cidrs" {
    description = "List of CIDR blocks for private subnets"
    type = list(string)
}

variable "availability_zones" {
    description = "List of availability zones"
    type = list(string)
}

variable "enable_single_nat_gateway" {
    description = "Enable single NAT gateway for cost optimization (non-prod environments)"
    type = bool
    default = false
}

variable "environment_type" {
    description = "Environment type (prod, staging, dev)"
    type = string
    default = "dev"
}