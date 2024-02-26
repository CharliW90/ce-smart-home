output "public_facing_security_group" {
  value = aws_security_group.public_facing.id
}