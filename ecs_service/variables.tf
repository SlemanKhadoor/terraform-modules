variable "alb_listener_arn" {
  description = "ARN of the ALB listener to attach the rule to"
  type        = string
}

variable "host_header" {
  description = "Host header to match for routing (e.g., api.prod.com)"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for ECS service and SG"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for ECS service"
  type        = list(string)
}

variable "container_name" {
  description = "Name of the container in the task definition"
  type        = string
}

variable "container_image" {
  description = "Container image URI"
  type        = string
}

variable "container_port" {
  description = "Port the container listens on"
  type        = number
}

variable "execution_role_arn" {
  description = "ARN of the ECS task execution role"
  type        = string
}

variable "task_role_arn" {
  description = "ARN of the ECS task role"
  type        = string
}

variable "ecs_cluster_arn" {
  description = "ARN of the ECS cluster"
  type        = string
}

variable "desired_count" {
  description = "Number of ECS tasks to run"
  type        = number
  default     = 1
}

variable "alb_sg_id" {
  description = "Security Group ID of the ALB"
  type        = string
}

# Task-level resources
variable "task_cpu" {
  description = "CPU units for the ECS task definition"
  type        = string
}

variable "task_memory" {
  description = "Memory (MB) for the ECS task definition"
  type        = string
}

variable "cpu_architecture" {
  description = "CPU architecture for the ECS task definition (e.g., X86_64)"
  type        = string
  default     = "X86_64"
}

variable "operating_system_family" {
  description = "Operating system family for the ECS task definition (e.g., LINUX)"
  type        = string
  default     = "LINUX"
}

# Container-level resources
variable "container_cpu" {
  description = "CPU units reserved for the container"
  type        = number
  default     = 0
}

variable "container_memory" {
  description = "Hard memory limit (MB) for the container"
  type        = number
}

variable "container_memory_reservation" {
  description = "Soft memory reservation (MB) for the container"
  type        = number
}

variable "log_retention_days" {
  description = "Number of days to retain CloudWatch logs"
  type        = number
  default     = 30
}

variable "health_check_grace_period_seconds" {
  description = "Seconds to ignore failing load balancer health checks on newly instantiated tasks"
  type        = number
  default     = 300
}

# Environment files
variable "environment_files" {
  description = "List of environment file objects for the container (arn/type)"
  type = list(object({
    value = string
    type  = string
  }))
  default = []
}

variable "priority" {
  description = "Priority for the ALB listener rule"
  type        = number
  default     = 100
}

variable "command" {
  description = "Optional command override for the container (e.g. [\"server\", \"/data\"])"
  type        = list(string)
  default     = null
}

variable "efs_volume" {
  description = "Optional EFS volume to mount into the container"
  type = object({
    file_system_id  = string
    access_point_id = string
    container_path  = string
  })
  default = null
}
