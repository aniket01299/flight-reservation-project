provider "aws" {
    region = "eu-north-1"
}

module "rds" {
    source = "./modules/rds"
}

module "eks" {
    source = "./modules/eks"
    project = "cbz"
    desired_nodes = 2
    max_nodes  = 2
    min_nodes  = 2
    node_instance_type = "c7i-flex.large"
}

module "s3" {
    source = "./modules/s3"
}