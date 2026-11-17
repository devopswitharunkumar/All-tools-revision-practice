resource "aws_ssm_parameter" "acm_cert_arn" {
  name  = "/${var.project_name}/${var.env_name}/acm_cert_arn"
  type  = "String"
  value = aws_acm_certificate.cert.arn
}