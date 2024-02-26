# Create Security Groups (check app requirements)

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

resource "aws_vpc_security_group_egress_rule" "outgoing_ipv4" {
  security_group_id = aws_security_group.public_facing.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"
}