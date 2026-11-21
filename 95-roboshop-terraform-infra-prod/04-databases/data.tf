
#fetching ami id from aws
data "aws_ami" "redhat-9-ami-id" {
  most_recent      = true
  owners           = ["973714476881"]

  filter {
    name   = "name"
    values = ["Redhat-9-DevOps-Practice"] #if vale randomlyy changes we can give like ["Redhat-9-DevOps-*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "aws_ssm_parameter" "mongodb_sg_id" {
    name = "/${var.project_name}/${var.env_name}/mongodb_sg_id"
}

data "aws_ssm_parameter" "redis_sg_id" {
  name = "/${var.project_name}/${var.env_name}/redis_sg_id"
}

data "aws_ssm_parameter" "mysql_sg_id" {
  name = "/${var.project_name}/${var.env_name}/mysql_sg_id"
}

data "aws_ssm_parameter" "rabbitmq_sg_id" {
  name = "/${var.project_name}/${var.env_name}/rabbitmq_sg_id"
}

data "aws_ssm_parameter" "vpn_sg_id" {
  name = "/${var.project_name}/${var.env_name}/vpn_sg_id"
}

#subnets related id's
data "aws_ssm_parameter" "database_subnet_id" {
    name = "/${var.project_name}/${var.env_name}/database_subnet_id"
}

data "aws_route53_zone" "domain_zone_id" {
    name = "devopswitharun.online"
    private_zone = false 
}

data "aws_vpc" "default_vpc_id" {
  default = true
}

data "aws_subnet" "default_subnet_from_default_vpc" {
    vpc_id = data.aws_vpc.default_vpc_id.id
    availability_zone = "us-east-1a" 
}