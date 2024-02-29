variable "public_apps" {
  type = list(string)
}

variable "private_apps" {
  type = list(string)
}

variable "main_vpc_id" {
  type = string
}

variable "public_tg_protocol" {
  type = string
  default = "HTTP"
}

variable "public_tg_protocol_version" {
  type = string
  default = "HTTP1"
}

variable "public_tg_port" {
  type = string
  default = "3000"
}

variable "private_tg_protocol" {
  type = string
  default = "HTTP"
}

variable "private_tg_protocol_version" {
  type = string
  default = "HTTP1"
}

variable "private_tg_port" {
  type = string
  default = "3000"
}

variable "health_check_path" {
  type = string
}

variable "health_check_protocol" {
  type = string
  default = "HTTP"
}

variable "public_security_groups" {
  type = list(string)
}

variable "public_subnets" {
  type = list(string)
}

variable "private_subnets" {
  type = list(string)
}

variable "delete_protect" {
  type = bool
  default = false
}