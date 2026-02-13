provider "aws" {
  region = var.region
}
# module VPC
module "vpc" {
  source         = "../../modules/vpc"
  vpc_cidr_block = var.vpc_cidr_block
  environment    = var.environment
}

module "subnet" {
  source          = "../../modules/subnets"
  vpc_id          = module.vpc.vpc_id
  environment     = var.environment
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
}

module "eks-cluster" {
  source       = "../../modules/eks-cluster"
  environment  = var.environment
  cluster_name = var.cluster_name
  vpc_id       = module.vpc.vpc_id
  subnet_ids   = module.subnet.private_subnet_ids

}

module "eks-nodes" {
  source          = "../../modules/eks-nodes"
  node_group_name = "${var.node_group_name}-v2"
  cluster_name    = module.eks-cluster.eks_cluster_name
  vpc_id          = module.vpc.vpc_id
  environment     = var.environment
  subnet_ids      = module.subnet.private_subnet_ids
  desired_size    = 4
  max_size        = 6
  min_size        = 4
  instance_types  = ["t3.micro"]
}
