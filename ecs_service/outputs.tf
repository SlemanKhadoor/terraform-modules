output "service_name" {
  description = "Name of the ECS service"
  value       = aws_ecs_service.this.name
}

output "service_security_group_id" {
  description = "Security Group ID for the ECS service tasks"
  value       = aws_security_group.ecs_service_sg.id
}

output "target_group_arn" {
  description = "ARN of the target group"
  value       = aws_lb_target_group.this.arn
}

output "log_group_name" {
  description = "Name of the CloudWatch Log Group for ECS container logs"
  value       = aws_cloudwatch_log_group.this.name
}
