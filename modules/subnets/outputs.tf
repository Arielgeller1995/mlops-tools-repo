output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = [for s in aws_subnet.public_subnet : s.id]
}

output "private_subnet_ids" {
  description = "List of private subnet IDs"
  value       = [for s in aws_subnet.private_subnet : s.id]
}

output "nat_gateway_id" {
  description = "ID of the NAT Gateway"
  value       = aws_nat_gateway.nat_gw.id
}

output "nat_gateway_subnet_id" {
  description = "Subnet ID where the NAT Gateway is placed"
  value       = aws_nat_gateway.nat_gw.subnet_id
}

output "internet_gateway_id" {
  description = "ID of the Internet Gateway"
  value       = aws_internet_gateway.igw.id
}

output "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  value       = [for s in aws_subnet.public_subnet : s.cidr_block]
}

output "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  value       = [for s in aws_subnet.private_subnet : s.cidr_block]
}
