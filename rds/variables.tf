variable "name" {
  description = "RDS instance name"
  type        = string
}

variable "engine" {
  description = "Database engine (postgres, mysql)"
  type        = string
}

variable "engine_version" {
  description = "Engine version"
  type        = string
}

variable "instance_class" {
  description = "RDS instance type"
  type        = string
}

variable "allocated_storage" {
  description = "Initial storage size (GB)"
  type        = number
}

variable "username" {
  description = "DB master username"
  type        = string
}

variable "password" {
  description = "DB master password"
  type        = string
  sensitive   = true
}

variable "db_name" {
  description = "Name of the initial database to create"
  type        = string
  default     = null
}

variable "subnet_ids" {
  description = "Private subnet IDs"
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "multi_az" {
  description = "Enable multi-AZ"
  type        = bool
  default     = false
}

variable "publicly_accessible" {
  description = "Expose DB publicly"
  type        = bool
  default     = false
}

variable "backup_retention_period" {
  description = "Backup retention days"
  type        = number
  default     = 7
}

variable "allowed_security_group_ids" {
  description = "List of security groups allowed to access the DB"
  type        = list(string)
  default     = []
}

variable "allowed_cidr_blocks" {
  description = "List of CIDR blocks allowed to access the DB"
  type        = list(string)
  default     = []
}

variable "backup_window" {
  description = "Backup window for RDS instance"
  type        = string
  default     = "03:00-04:00"
}

variable "maintenance_window" {
  description = "Maintenance window for RDS instance"
  type        = string
  default     = "sun:04:00-sun:05:00"
}

variable "skip_final_snapshot" {
  description = "Skip final snapshot when deleting RDS instance"
  type        = bool
  default     = false
}

variable "deletion_protection" {
  description = "Enable deletion protection for RDS instance"
  type        = bool
  default     = true
}

variable "apply_immediately" {
  description = "Apply changes immediately instead of waiting for maintenance window"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags to apply to RDS resources"
  type        = map(string)
  default     = {}
}

# Cross-region backup variables
variable "enable_cross_region_backup" {
  description = "Enable cross-region automated backup"
  type        = bool
  default     = false
}

variable "backup_destination_region" {
  description = "Destination region for cross-region backups"
  type        = string
  default     = "eu-west-1" # Ireland
}

variable "cross_region_backup_kms_key_id" {
  description = "KMS key ID for cross-region backup encryption"
  type        = string
  default     = null
}

variable "max_allocated_storage" {
  description = "Maximum storage for autoscaling (0 = disabled)"
  type        = number
  default     = 0
}

variable "storage_type" {
  description = "Storage type"
  type        = string
  default     = "gp2"
}