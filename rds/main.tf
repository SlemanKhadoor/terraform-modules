# =====================================
# DB Subnet Group
# =====================================
resource "aws_db_subnet_group" "this" {
  name       = "${var.name}-subnet-group"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "${var.name}-subnet-group"
  }
}

# =====================================
# Security Group for RDS
# =====================================
resource "aws_security_group" "rds" {
  name        = "${var.name}-rds-sg"
  description = "Security group for RDS"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.name}-rds-sg"
  }
}

# =====================================
# Security Group Rules (Dynamic Access)
# =====================================
resource "aws_security_group_rule" "allow_db_access" {
  for_each = toset(var.allowed_security_group_ids)

  type                     = "ingress"
  from_port                = var.engine == "postgres" ? 5432 : 3306
  to_port                  = var.engine == "postgres" ? 5432 : 3306
  protocol                 = "tcp"
  security_group_id        = aws_security_group.rds.id
  source_security_group_id = each.value
}

# CIDR-based access (for private subnets)
resource "aws_security_group_rule" "allow_db_cidr_access" {
  count = length(var.allowed_cidr_blocks) > 0 ? 1 : 0

  type              = "ingress"
  from_port         = var.engine == "postgres" ? 5432 : 3306
  to_port           = var.engine == "postgres" ? 5432 : 3306
  protocol          = "tcp"
  cidr_blocks       = var.allowed_cidr_blocks
  security_group_id = aws_security_group.rds.id
}

# =====================================

# Get the KMS key ARN from alias in the backup region
data "aws_kms_key" "backup_region_rds_key" {
  count = var.enable_cross_region_backup ? 1 : 0
  
  key_id   = var.cross_region_backup_kms_key_id != null ? var.cross_region_backup_kms_key_id : "alias/aws/rds"
  provider = aws.backup_region
}

# =====================================
# Parameter Group
# =====================================
resource "aws_db_parameter_group" "this" {
  name        = "${var.name}-pg"
  family      = "postgres16"
  description = "Custom parameter group for ${var.name}"

  parameter {
    name         = "rds.force_ssl"
    value        = "0"
    apply_method = "pending-reboot"
  }

  tags = var.tags
}

# =====================================
# RDS Instance
# =====================================
resource "aws_db_instance" "this" {
  identifier = var.name

  engine         = var.engine
  engine_version = var.engine_version
  instance_class = var.instance_class

  allocated_storage     = var.allocated_storage
  max_allocated_storage = var.max_allocated_storage > 0 ? var.max_allocated_storage : null
  storage_type          = var.storage_type

  username = var.username
  password = var.password

  db_name = var.db_name

  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = [aws_security_group.rds.id]

  multi_az            = var.multi_az
  publicly_accessible = var.publicly_accessible

  # Backup configuration
  backup_retention_period = var.backup_retention_period
  backup_window          = var.backup_window
  maintenance_window     = var.maintenance_window

  # Snapshot configuration
  skip_final_snapshot       = var.skip_final_snapshot
  final_snapshot_identifier = var.skip_final_snapshot ? null : "${var.name}-final-snapshot"
  deletion_protection       = var.deletion_protection
  
  # Apply changes
  apply_immediately = var.apply_immediately

  # Parameter group
  parameter_group_name = aws_db_parameter_group.this.name

  # Security
  storage_encrypted = true

  tags = var.tags
}

# =====================================
# Cross-Region Automated Backup
# =====================================
resource "aws_db_instance_automated_backups_replication" "cross_region" {
  count = var.enable_cross_region_backup ? 1 : 0

  source_db_instance_arn = aws_db_instance.this.arn
  kms_key_id            = data.aws_kms_key.backup_region_rds_key[0].arn
  provider = aws.backup_region

}