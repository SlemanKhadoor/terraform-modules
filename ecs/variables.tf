variable "cluster_name" {
  description = "Name of the ECS cluster"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where ECS cluster will be created"
  type        = string
}

variable "service_connect_namespace" {
  description = "Name of the Service Connect namespace"
  type        = string
  default     = "WatermelonProd"
}

variable "enable_container_insights" {
  description = "Enable CloudWatch Container Insights"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}

variable "task_execution_role_policies" {
  description = "List of additional policy ARNs to attach to the ECS task execution role"
  type        = list(string)
  default     = []
}

variable "task_role_policies" {
  description = "List of policy ARNs to attach to the ECS task role"
  type        = list(string)
  default     = []
}