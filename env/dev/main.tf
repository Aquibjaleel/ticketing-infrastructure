module "hub" {
    source="../../modules/hub-network"
    vpc_cidr = "10.0.0.0/16"

    aws_region = var.aws_region
  
}
module "spoke" {
  source                = "../../modules/spoke-network"
  aws_region            = var.aws_region
  vpc_cidr              = "10.1.0.0/16"
  
  # Update this to match the new split variables:
  private_subnet_cidr_a = "10.1.0.0/20"
  private_subnet_cidr_b = "10.1.16.0/20"
}

resource "aws_vpc_peering_connection" "hub_spoke" {
  vpc_id        = module.hub.vpc_id
  peer_vpc_id   = module.spoke.vpc_id
  peer_region   = var.aws_region

  tags          = { Name = "Hub-Spoke-Peering" }
}

module "ecr" {
    source = "../../modules/ecr"
    repo_name = "my-ecr-repo"
}

module "app_gateway" {
    source = "../../modules/app-gateway"
    vpc_id = module.hub.vpc_id
    public_subnet_ids = module.hub.public_subnet_ids
}
module "mysql" {
    source = "../../modules/mysql"
    db_name = "mydb"
    admin_username = "dbadmin"
    admin_password = "SecurePassword123!"
}
module "secrets-manager" {
    source = "../../modules/secrets-manager"
    secret_name = "dev-db-credentials"
}

module "backend_storage" {
  source = "../../modules/backend-storage"
  # Removed the bucket_name = "dev-terraform-state-bucket" override line!
}

module "eks" {
  source           = "../../modules/eks"
  eks_cluster_name = "skillslab-ticketing-cluster-dev"
  
  # Pointing to Hub subnets
  private_subnet_ids = module.hub.public_subnet_ids 

  depends_on = [module.hub]
}