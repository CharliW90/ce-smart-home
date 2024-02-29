# Create VPC [./modules/servers]

module "vpc" {
  source = "./modules/servers"

  core_name = var.vpc_name
  cidr_block = var.cidr_range
  availability_zones = var.availability_zones
  public_subnets = var.public_subnets
  private_subnets = var.private_subnets
}

# Create Security Groups (check app requirements) [./modules/security]

module "security" {
  source = "./modules/security"

  vpc_id = module.vpc.vpc_id
}

# Create EC2 per application (4) [./modules/instances]

module "instances" {
  source = "./modules/instances"

  public_apps = var.public_apps
  private_apps = var.private_apps
  public_subnets = module.vpc.public_subnets
  private_subnets = module.vpc.private_subnets
  keyPair = var.key_name
  public_security_group_ids = [module.security.public_facing_security_group]
  private_security_group_ids = [module.security.private_ssh_security_group]
  root_github_owner = "https://github.com/CharliW90"
}

# Create different target groups for the services [./modules/load_balancing]
# Add load balancing [./modules/load_balancing]

module "load_balancing" {
  depends_on = [ module.instances ]
  source = "./modules/load_balancing"

  main_vpc_id = module.vpc.vpc_id
  public_apps = var.public_apps
  private_apps = var.private_apps
  health_check_path = "/api/status/health"
  public_subnets = module.vpc.public_subnets
  public_security_groups = [module.security.public_facing_security_group]
  private_subnets = module.vpc.private_subnets

  # delete_protect = true
}

# Creat .env.local file for upload to centralised app
# resource "local_file" ".env.local_file" {
#   content  = "LIGHTS_SERVICE=${relevant.public_dns}:3000\nHEATING_SERVICE=${relevant.public_dns}:3000\nAUTH_SERVICE=${relevant.public_dns}:3000"
#   filename = ".env.local"
# }
