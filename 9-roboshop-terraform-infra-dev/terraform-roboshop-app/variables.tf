#mandatory variables related
variable "project_name" {
    type = string
}

variable "env_name" {
    type = string
}

variable "common_tags" {
}

variable "tags" {
    default = {}
}

variable "vpc_id" {
}

variable "component_sg_id" {
}

variable "private_subnet_id" {
}

variable "iam_instance_profile" {
}

variable "domain_name" {
}

variable "ami_id" {
}

variable "app_alb_listner_rule" {
  
}

variable "rule_priority" {
  
}

variable "app_version" {
  type    = string
  default = ""
}

variable "packaging" {
  description = "Application artifact packaging format"
  type        = string
  default     = "zip"
}

variable "port" {
    default = 8080
}

variable "host_header_pattern" {
  description = "Host header pattern for ALB listener rule"
  type        = string
}