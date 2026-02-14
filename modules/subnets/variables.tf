variable "vpc_id" {
  type        = string
  description = "VPC ID to associate subnets and other resources with"
}

variable "environment" {
  type        = string
  description = "Deployment environment (dev, staging, prod)"
}

variable "public_subnets" {
  type = map(object({
    cidr = string
    az   = string
  }))
  description = "Map of public subnets with AZs"
}

variable "private_subnets" {
  type = map(object({
    cidr = string
    az   = string
  }))
  description = "Map of private subnets with AZs"
}

variable "enable_nat_gateway" {
  type        = bool
  description = "Whether to create a NAT Gateway for private subnet egress (costly). If false, private subnets will not have internet egress by default."
  default     = false
}
