output "public_instances_retrieved" {
  value = data.aws_instances.public_apps_as_instance[*]
}

output "private_instances_retrieved" {
  value = data.aws_instances.private_apps_as_instance[*]
}