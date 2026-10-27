resource "aws_ssm_parameter" "app_alb_listner_rule" {
  name  = "/${var.project_name}/${var.env_name}/app_alb_listner_rule"
  type  = "String"
  value = aws_lb_listener.http_listner.arn
}
