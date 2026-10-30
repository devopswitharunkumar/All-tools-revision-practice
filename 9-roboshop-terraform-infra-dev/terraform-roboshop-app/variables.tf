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