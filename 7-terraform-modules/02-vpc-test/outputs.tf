output "azs" {
  value = module.vpc.azs
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "vpc_cidr_block" {
  value = module.vpc.vpc_cidr_block
}

output "nat_gateway_id" {
  value = module.vpc.nat_gateway_id
}

output "public_subnet_id" {
  value = module.vpc.public_subnet_id
}

output "private_subnet_id" {
  value = module.vpc.private_subnet_id
}

output "database_subnet_id" {
  value = module.vpc.database_subnet_id
}

output "elastic_ip_id" {
  value = module.vpc.elastic_ip_id
}

output "nat_gateway_ids" {
  value = module.vpc.nat_gateway_id
}

output "public_route_table_id" {
  value = module.vpc.public_route_table_id
}

output "private_route_table_id" {
  value = module.vpc.private_route_table_id
}

output "database_route_table_id" {
  value = module.vpc.database_route_table_id
}
