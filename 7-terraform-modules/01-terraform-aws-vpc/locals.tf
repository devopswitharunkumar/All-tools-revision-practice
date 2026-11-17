locals {
  resource_name = "${var.project_name}-${var.env_name}"
  azs_names = slice(data.aws_availability_zones.azs.names,0,2)
}