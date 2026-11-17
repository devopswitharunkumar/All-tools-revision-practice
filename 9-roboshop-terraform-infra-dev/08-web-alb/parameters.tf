resource "aws_ssm_parameter" "web_alb_listner_rule" {
  name  = "/${var.project_name}/${var.env_name}/web_alb_listner_rule"
  type  = "String"
  value = aws_lb_listener.https_listner.arn
}
