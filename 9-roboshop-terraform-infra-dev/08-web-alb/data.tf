data "aws_ssm_parameter" "web_alb_sg_id" {
    name = "/${var.project_name}/${var.env_name}/web_alb_sg_id"
}

data "aws_ssm_parameter" "public_subnet_id" {
    name = "/${var.project_name}/${var.env_name}/public_subnet_id"
}

data "aws_ssm_parameter" "acm_cert_arn" {
    name = "/${var.project_name}/${var.env_name}/acm_cert_arn"
}

data "aws_route53_zone" "zone_id" {
    name = "devopswitharun.online"
    private_zone = false  
}


data "aws_ssm_parameter" "vpc_id" {
    name = "/${var.project_name}/${var.env_name}/vpc_id"
}