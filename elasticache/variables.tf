variable "name" {
  description = "Name prefix for all ElastiCache resources"
  type        = string
}

variable "description" {
  description = "Description for the replication group"
  type        = string
  default     = "Managed by Terraform"
}

variable "vpc_id" {
  description = "VPC ID where the ElastiCache cluster will be deployed"
  type        = string
}

variable "subnet_ids" {
  description = "List of private subnet IDs for the ElastiCache subnet group"
  type        = list(string)
}

variable "node_type" {
  description = "ElastiCache node type (e.g. cache.t3.micro, cache.r7g.large)"
  type        = string
  default     = "cache.t3.micro"
}

variable "engine_version" {
  description = "Redis engine version"
  type        = string
  default     = "7.1"
}

variable "port" {
  description = "Port for the Redis instance"
  type        = number
  default     = 6379
}

variable "parameter_group_family" {
  description = "ElastiCache parameter group family (e.g. redis7)"
  type        = string
  default     = "redis7"
}

variable "parameters" {
  description = "List of custom parameter group parameters"
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

# =====================================
# Cluster / Replication settings
# =====================================
variable "cluster_mode_enabled" {
  description = "Enable Redis cluster mode (multiple shards). Set to false for a single shard (standard replication group)."
  type        = bool
  default     = false
}

variable "num_shards" {
  description = "Number of shards (node groups). Only used when cluster_mode_enabled = true."
  type        = number
  default     = 1
}

variable "num_replicas" {
  description = "Number of read replicas per shard. Set to 0 for a single-node instance."
  type        = number
  default     = 1
}

variable "multi_az_enabled" {
  description = "Enable Multi-AZ for the replication group. Requires num_replicas >= 1."
  type        = bool
  default     = false
}

# =====================================
# Encryption
# =====================================
variable "at_rest_encryption_enabled" {
  description = "Enable encryption at rest"
  type        = bool
  default     = true
}

variable "transit_encryption_enabled" {
  description = "Enable in-transit encryption (TLS). Required to use auth_token."
  type        = bool
  default     = true
}

variable "auth_token" {
  description = "Auth token (password) for Redis. Only used when transit_encryption_enabled = true."
  type        = string
  default     = null
  sensitive   = true
}

# =====================================
# Maintenance & Snapshots
# =====================================
variable "snapshot_retention_limit" {
  description = "Number of days to retain automatic snapshots. 0 disables snapshots."
  type        = number
  default     = 7
}

variable "snapshot_window" {
  description = "Daily time range (UTC) for automatic snapshots (e.g. 05:00-06:00)"
  type        = string
  default     = "05:00-06:00"
}

variable "maintenance_window" {
  description = "Weekly maintenance window (e.g. sun:23:00-mon:01:00)"
  type        = string
  default     = "sun:23:00-mon:01:00"
}

variable "apply_immediately" {
  description = "Apply changes immediately or during the next maintenance window"
  type        = bool
  default     = false
}

# =====================================
# Access
# =====================================
variable "allowed_security_group_ids" {
  description = "List of security group IDs allowed to connect to Redis"
  type        = list(string)
  default     = []
}

variable "allowed_cidr_blocks" {
  description = "List of CIDR blocks allowed to connect to Redis"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
