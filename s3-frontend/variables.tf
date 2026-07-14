variable "name" {
  description = "Name prefix for S3 frontend resources"
  type        = string
}

variable "index_document" {
  description = "Index document for S3 website"
  type        = string
  default     = "index.html"
}

variable "error_document" {
  description = "Error document for S3 website"
  type        = string
  default     = "error.html"
}

variable "enable_website_hosting" {
  description = "Enable S3 website hosting (not needed for CloudFront-only access)"
  type        = bool
  default     = false
}

variable "enable_versioning" {
  description = "Enable S3 bucket versioning"
  type        = bool
  default     = true
}

variable "cloudfront_distribution_arn" {
  description = "CloudFront distribution ARN for OAC access (required for CloudFront-only access)"
  type        = string
  default     = null
}

variable "tags" {
  description = "Additional tags to assign to resources"
  type        = map(string)
  default     = {}
}