output "azs" {
  value = module.roboshop_vpc.azs
}

output "roboshop_vpc_id" {
  value = module.roboshop_vpc.vpc_id
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



