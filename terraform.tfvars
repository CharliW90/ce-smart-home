vpc_name = "ce-smart-home"
cidr_range = "10.0.0.0/16"
availability_zones = ["eu-west-2a", "eu-west-2b", "eu-west-2c"]
public_subnets = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24"]
private_subnets = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

public_apps = ["ce-smart-home-heating","ce-smart-home-lights","ce-smart-home-status"]
private_apps = ["ce-smart-home-auth"]
