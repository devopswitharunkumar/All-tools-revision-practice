data "aws_ssm_parameter" "vpc_id" {
    name = "/${var.project_name}/${var.env_name}/vpc_id"
}