variable "public_apps" {
  type = list(string)
}

variable "private_apps" {
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