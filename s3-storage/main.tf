resource "aws_s3_bucket" "storage" {
  bucket = "${var.name}-storage"

  tags = merge({
    Name = "${var.name}-storage"
  }, var.tags)
}

resource "aws_s3_bucket_ownership_controls" "storage" {
  count  = var.object_ownership != null ? 1 : 0
  bucket = aws_s3_bucket.storage.id

  rule {
    object_ownership = var.object_ownership
  }
}

resource "aws_s3_bucket_versioning" "storage" {
  count  = var.enable_versioning ? 1 : 0
  bucket = aws_s3_bucket.storage.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "storage" {
  count  = var.enable_encryption ? 1 : 0
  bucket = aws_s3_bucket.storage.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = var.encryption_algorithm
    }
    bucket_key_enabled = true
    blocked_encryption_types = ["SSE-C"]
  }
}

resource "aws_s3_bucket_public_access_block" "storage" {
  bucket = aws_s3_bucket.storage.id

  block_public_acls       = !var.disable_public_access_block
  block_public_policy     = !var.disable_public_access_block
  ignore_public_acls      = !var.disable_public_access_block
  restrict_public_buckets = !var.disable_public_access_block
}

resource "aws_s3_bucket_policy" "public_read" {
  count  = var.allow_public_read ? 1 : 0
  bucket = aws_s3_bucket.storage.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "AllowPublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.storage.arn}/*"
      }
    ]
  })

  depends_on = [aws_s3_bucket_public_access_block.storage]
}

resource "aws_s3_bucket_lifecycle_configuration" "storage" {
  count  = var.lifecycle_expiration_days != null || var.lifecycle_transition_days != null ? 1 : 0
  bucket = aws_s3_bucket.storage.id
  depends_on = [aws_s3_bucket_versioning.storage]

  rule {
    id     = "lifecycle"
    status = "Enabled"

    dynamic "expiration" {
      for_each = var.lifecycle_expiration_days != null ? [1] : []
      content {
        days = var.lifecycle_expiration_days
      }
    }

    dynamic "transition" {
      for_each = var.lifecycle_transition_days != null ? [1] : []
      content {
        days          = var.lifecycle_transition_days
        storage_class = "STANDARD_IA"
      }
    }
  }
}