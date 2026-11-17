locals {
  ec2_name = "${var.project_name}-${var.env_name}"
  current_timestamp = formatdate("YYYY-MM-DD-hh-mm", timestamp())
}