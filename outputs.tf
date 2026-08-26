output "vpc_id" {
  value = module.network.vpc_id
}

output "public_subnet_id" {
  value = module.network.public_subnet_id
}

output "private_subnet_id" {
  value = module.network.private_subnet_id
}

output "web_public_ips" {
  value = module.compute.web_public_ips
}

output "db_private_ip" {
  value = module.compute.db_private_ip
}
