# =====================================
# ElastiCache Subnet Group
# =====================================
resource "aws_elasticache_subnet_group" "this" {
  name       = "${var.name}-subnet-group"
  subnet_ids = var.subnet_ids

  tags = merge(var.tags, {
    Name = "${var.name}-subnet-group"
  })
}

# =====================================
# Security Group for ElastiCache
# =====================================
resource "aws_security_group" "this" {
  name        = "${var.name}-elasticache-sg"
  description = "Security group for ElastiCache ${var.name}"
  vpc_id      = var.vpc_id

  tags = merge(var.tags, {
    Name = "${var.name}-elasticache-sg"
  })
}

# =====================================
# Security Group Rules
# =====================================
resource "aws_security_group_rule" "allow_redis_sg" {
  for_each = toset(var.allowed_security_group_ids)

  type                     = "ingress"
  from_port                = var.port
  to_port                  = var.port
  protocol                 = "tcp"
  security_group_id        = aws_security_group.this.id
  source_security_group_id = each.value
}

resource "aws_security_group_rule" "allow_redis_cidr" {
  count = length(var.allowed_cidr_blocks) > 0 ? 1 : 0

  type              = "ingress"
  from_port         = var.port
  to_port           = var.port
  protocol          = "tcp"
  cidr_blocks       = var.allowed_cidr_blocks
  security_group_id = aws_security_group.this.id
}

# =====================================
# Parameter Group
# =====================================
resource "aws_elasticache_parameter_group" "this" {
  name        = "${var.name}-params"
  family      = var.parameter_group_family
  description = "Parameter group for ${var.name}"

  dynamic "parameter" {
    for_each = var.parameters
    content {
      name  = parameter.value.name
      value = parameter.value.value
    }
  }

  tags = var.tags
}

# =====================================
# ElastiCache Replication Group (Redis)
# Covers both single-node and cluster mode
# =====================================
resource "aws_elasticache_replication_group" "this" {
  replication_group_id = var.name
  description          = var.description

  engine               = "redis"
  engine_version       = var.engine_version
  node_type            = var.node_type
  port                 = var.port
  parameter_group_name = aws_elasticache_parameter_group.this.name
  subnet_group_name    = aws_elasticache_subnet_group.this.name
  security_group_ids   = [aws_security_group.this.id]

  # Cluster mode
  num_node_groups         = var.cluster_mode_enabled ? var.num_shards : 1
  replicas_per_node_group = var.num_replicas

  # Automatic failover requires at least 2 nodes total
  automatic_failover_enabled = var.num_replicas >= 1 ? true : false
  multi_az_enabled           = var.multi_az_enabled

  # Encryption
  at_rest_encryption_enabled = var.at_rest_encryption_enabled
  transit_encryption_enabled = var.transit_encryption_enabled
  auth_token                 = var.transit_encryption_enabled && var.auth_token != null ? var.auth_token : null

  # Maintenance & Snapshots
  snapshot_retention_limit = var.snapshot_retention_limit
  snapshot_window          = var.snapshot_window
  maintenance_window       = var.maintenance_window

  apply_immediately = var.apply_immediately

  tags = merge(var.tags, {
    Name = var.name
  })
}
