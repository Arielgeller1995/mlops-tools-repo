output "vpc_id" {
  description = "The ID of the created VPC"
  value       = aws_vpc.main.id
}

output "vpc_tags" {
  description = "Tags assigned to the VPC"
  value       = aws_vpc.main.tags
}
