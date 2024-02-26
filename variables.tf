variable "vpc_name" {
  type = string
}

variable "cidr_range" {
  type = string
}

variable "availability_zones" {
  type = list(string)
}

variable "public_subnets" {
  type = list(string)
}

variable "private_subnets" {
  type = list(string)
}

variable "key_name" {
  type = string
  default = "deployer-key"
}

variable "app_names" {
  type = list(string)
}