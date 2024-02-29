output "public_instances_retrieved" {
  value = data.aws_instances.public_apps_as_instance[*]
}

output "private_instances_retrieved" {
  value = data.aws_instances.private_apps_as_instance[*]
}

output "public-lb-dns" {
  value = aws_lb.public_load_balancer[*].dns_name
}

output "private-lb-dns" {
  value = aws_lb.private_load_balancer[*].dns_name
  description = "for use on internal machines only"
}