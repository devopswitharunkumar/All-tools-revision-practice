#mandatory variables related to name
variable "project_name" {
    type = string
    default = "roboshop"
}

variable "env_name" {
    type = string
    # default = "dev"
}

variable "common_tags" {
    # default = {
    #     Project = "roboshop"
    #     Terraform = true 
    #     Environment = "dev"
    # }
}

variable "tags" {
    default = {
        Component = "payment"
    }
}

variable "app_version" {
  type    = string
  default = ""
}

variable "rule_priority" {
    default = 50
}

variable "iam_instance_profile" {
    default = "EC2RoleForShellScript"
}

variable "host_header_pattern" {
  description = "Host header pattern"
  type        = string
  default     = "%s.app-%s.%s"
}