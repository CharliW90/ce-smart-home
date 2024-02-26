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
}

# Create EC2 per application (4) [./modules/instances]

module "instances" {
  source = "./modules/instances"
}

# Create different target groups for the services [./modules/load_balancing]
# Add load balancing [./modules/load_balancing]

module "load_balancing" {
  source = "./modules/load_balancing"
}

# Creat .env.local file for upload to centralised app
# resource "local_file" ".env.local_file" {
#   content  = "LIGHTS_SERVICE=${relevant.public_dns}:3000\nHEATING_SERVICE=${relevant.public_dns}:3000\nAUTH_SERVICE=${relevant.public_dns}:3000"
#   filename = ".env.local"
# }