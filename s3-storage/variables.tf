variable "name" {
  description = "Name prefix for S3 storage resources"
  type        = string
}

variable "enable_versioning" {
  description = "Enable S3 bucket versioning"
  type        = bool
  default     = true
}

variable "enable_encryption" {
  description = "Enable S3 bucket encryption"
  type        = bool
  default     = true
}

variable "encryption_algorithm" {
  description = "Encryption algorithm for S3 bucket"
  type        = string
  default     = "AES256"
}

variable "lifecycle_expiration_days" {
  description = "Number of days after which objects are expired"
  type        = number
  default     = null
}

variable "lifecycle_transition_days" {
  description = "Number of days after which objects are transitioned to IA"
  type        = number
  default     = null
}

variable "tags" {
  description = "Additional tags to assign to resources"
  type        = map(string)
  default     = {}
}

variable "disable_public_access_block" {
  description = "Disable S3 public access block settings for buckets that must be publicly readable"
  type        = bool
  default     = false
}

variable "allow_public_read" {
  description = "Attach a public-read bucket policy (s3:GetObject for all objects)"
  type        = bool
  default     = false
}

variable "object_ownership" {
  description = "S3 object ownership setting. Set to BucketOwnerEnforced to disable ACL dependency"
  type        = string
  default     = null
}