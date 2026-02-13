variable "environment" {
  description = "Deployment environment (e.g., dev, staging, prod)"
}

variable "cluster_name" {
  type        = string
  description = "Name of the EKS cluster"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID to associate the EKS cluster with"
}

variable "subnet_ids" {
  type        = list(string)
  description = "Subnet IDs for the EKS cluster VPC config"

  validation {
    condition     = length(var.subnet_ids) >= 1
    error_message = "subnet_ids must contain at least one subnet id."
  }
}

variable "eks_version" {
  type        = string
  default     = "1.31"
  description = "The EKS cluster version to deploy"
}
