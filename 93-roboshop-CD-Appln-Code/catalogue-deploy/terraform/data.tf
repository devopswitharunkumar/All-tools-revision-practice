
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

data "aws_ssm_parameter" "app_alb_sg_id" {
    name = "/${var.project_name}/${var.env_name}/app_alb_sg_id"
}

data "aws_ssm_parameter" "private_subnet_id" {
    name = "/${var.project_name}/${var.env_name}/private_subnet_id"
}

data "aws_route53_zone" "zone_id" {
    name = "devopswitharun.online"
    private_zone = false 
}

variable "domain_name" {
  default = "devopswitharun.online"
}



data "aws_ssm_parameter" "vpc_id" {
    name = "/${var.project_name}/${var.env_name}/vpc_id"
}

data "aws_ssm_parameter" "catalogue_sg_id" {
    name = "/${var.project_name}/${var.env_name}/catalogue_sg_id"
}

data "aws_ssm_parameter" "app_alb_listner_rule" {
    name = "/${var.project_name}/${var.env_name}/app_alb_listner_rule"
}