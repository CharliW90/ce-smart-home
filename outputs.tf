output "public_instances_retrieved" {
  value = module.load_balancing.public_instances_retrieved[*].ids
}

output "private_instances_retrieved" {
  value = module.load_balancing.private_instances_retrieved[*].ids
}