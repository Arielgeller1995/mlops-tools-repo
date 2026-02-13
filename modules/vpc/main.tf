resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr_block
  instance_tenancy = var.instance_tenancy

  tags = {
    Name        = "${var.environment}-vpc"
    Environment = var.environment
  }
}