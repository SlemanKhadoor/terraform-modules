output "primary_endpoint" {
  description = "Primary endpoint address for the Redis replication group (single-shard / non-cluster mode)"
  value       = var.cluster_mode_enabled ? null : aws_elasticache_replication_group.this.primary_endpoint_address
}

output "reader_endpoint" {
  description = "Reader endpoint address (non-cluster mode, for read replicas)"
  value       = var.cluster_mode_enabled ? null : aws_elasticache_replication_group.this.reader_endpoint_address
}

output "configuration_endpoint" {
  description = "Configuration endpoint for cluster mode enabled replication groups"
  value       = var.cluster_mode_enabled ? aws_elasticache_replication_group.this.configuration_endpoint_address : null
}

output "port" {
  description = "Redis port"
  value       = var.port
}

output "security_group_id" {
  description = "ID of the ElastiCache security group"
  value       = aws_security_group.this.id
}

output "replication_group_id" {
  description = "ID of the ElastiCache replication group"
  value       = aws_elasticache_replication_group.this.id
}

output "parameter_group_name" {
  description = "Name of the parameter group"
  value       = aws_elasticache_parameter_group.this.name
}

output "subnet_group_name" {
  description = "Name of the ElastiCache subnet group"
  value       = aws_elasticache_subnet_group.this.name
}
