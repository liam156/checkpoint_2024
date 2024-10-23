output "vpc_id" {
  description = "ID of the created VPC"
  value       = module.vpc.vpc_id
}

output "public_subnets" {
  description = "IDs of the public subnets"
  value       = module.vpc.public_subnets
}

output "load_balancer_dns" {
  value = aws_lb.app_lb.dns_name
}

output "sqs_queue_url" {
  value = aws_sqs_queue.app_queue.id
}

output "s3_bucket_name" {
  value = aws_s3_bucket.app_bucket.id
}

output "ecs_service_name" {
  value = aws_ecs_service.microservice1_service.name
}