# Create Security Groups (check app requirements)

data "http" "myipaddr" {
  url = "http://ipv4.icanhazip.com"
}

resource "aws_security_group" "public_facing" {
  name        = "public-facing-security-group"
  description = "Security group for instances to communicate publicly"
  vpc_id      = var.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "app_port_ipv4" {
  security_group_id = aws_security_group.public_facing.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 3000
  ip_protocol = "tcp"
  to_port     = 3000
}

resource "aws_vpc_security_group_ingress_rule" "public_ssh_tunnel" {
  security_group_id = aws_security_group.public_facing.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 22
  ip_protocol = "tcp"
  to_port     = 22
}

resource "aws_vpc_security_group_egress_rule" "outgoing_ipv4" {
  security_group_id = aws_security_group.public_facing.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"
}

resource "aws_security_group" "private_ssh" {
  name        = "private-ssh-connections-security-group"
  description = "Security group for ssh connections to private instances"
  vpc_id      = var.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "private_ssh_tunnel" {
  security_group_id = aws_security_group.private_ssh.id

  cidr_ipv4   = "${chomp(data.http.myipaddr.response_body)}/32"
  from_port   = 22
  ip_protocol = "tcp"
  to_port     = 22
}

resource "aws_vpc_security_group_ingress_rule" "internal_comms" {
  security_group_id = aws_security_group.public_facing.id

  cidr_ipv4   = "10.0.0.0/16"
  from_port   = 3000
  ip_protocol = "tcp"
  to_port     = 3000
}

resource "aws_vpc_security_group_egress_rule" "private_outgoing_ipv4" {
  security_group_id = aws_security_group.private_ssh.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"
}