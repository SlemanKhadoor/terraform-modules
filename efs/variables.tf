variable "name" {
  description = "Name of the EFS"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR"
  type        = string
}

variable "subnet_ids" {
  description = "Private subnet IDs"
  type        = list(string)
}

variable "enable_backup" {
  description = "Enable automated EFS backup"
  type        = bool
  default     = false
}