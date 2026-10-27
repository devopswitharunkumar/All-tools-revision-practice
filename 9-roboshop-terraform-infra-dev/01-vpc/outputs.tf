output "azs" {
  value = module.roboshop_vpc.azs
}

output "roboshop_vpc_id" {
  value = module.roboshop_vpc.vpc_id
}

output "roboshop_vpc_cidr_block" {
  value = module.roboshop_vpc.vpc_cidr_block
}

output "public_subnet_id" {
  value = module.roboshop_vpc.public_subnet_id
}

output "private_subnet_id" {
  value = module.roboshop_vpc.private_subnet_id
}

output "database_subnet_id" {
  value = module.roboshop_vpc.database_subnet_id
}

output "elastic_ip_id" {
  value = module.roboshop_vpc.elastic_ip_id
}

output "nat_gateway_ids" {
  value = module.roboshop_vpc.nat_gateway_id
}

output "public_route_table_id" {
  value = module.roboshop_vpc.public_route_table_id
}

output "private_route_table_id" {
  value = module.roboshop_vpc.private_route_table_id
}

output "database_route_table_id" {
  value = module.roboshop_vpc.database_route_table_id
}
