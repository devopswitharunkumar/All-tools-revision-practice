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

