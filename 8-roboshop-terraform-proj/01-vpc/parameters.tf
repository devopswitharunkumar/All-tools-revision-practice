resource "aws_ssm_parameter" "vpc_id" {
  name = "/${var.project_name}/${var.env_name}/vpc_id"
  type = "String"
  value = module.roboshop_vpc.vpc_id  
}

resource "aws_ssm_parameter" "public_subnet_id" {
  name = "/${var.project_name}/${var.env_name}/public_subnet_id"
  type = "StringList"
  value = join(",", module.roboshop_vpc.public_subnet_id) 
}

resource "aws_ssm_parameter" "private_subnet_id" {
  name = "/${var.project_name}/${var.env_name}/private_subnet_id"
  type = "StringList"
  value = join(",", module.roboshop_vpc.private_subnet_id) 
}

resource "aws_ssm_parameter" "database_subnet_id" {
  name = "/${var.project_name}/${var.env_name}/database_subnet_id"
  type = "StringList"
  value = join(",", module.roboshop_vpc.database_subnet_id) 
}

output "database_subnet_ids" {
  value = module.roboshop_vpc.database_subnet_id 
}