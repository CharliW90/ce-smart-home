variable "public_apps" {
  type = list(string)
}

variable "private_apps" {
  type = list(string)
}

variable "public_security_group_ids" {
  type = list(string)
}

variable "private_security_group_ids" {
  type = list(string)
}

variable "instance_type" {
  type = string
  default = "t2.micro"
}

variable "public_subnets" {
  type = list(string)
}

variable "private_subnets" {
  type = list(string)
}

variable "keyPair" {
  type = string
}

variable "root_github_owner" {
  type = string
}