output "public_dns_url_to_visit" {
  value = module.load_balancing.public-lb-dns
}

output "private_dns_url_for_internal_routing" {
  value = module.load_balancing.private-lb-dns
}