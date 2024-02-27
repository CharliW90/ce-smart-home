output "private_app_instance_ids" {
  value = aws_instance.private_app[*].id
}

output "public_app_instance_ids" {
  value = aws_instance.public_app[*].id
}

