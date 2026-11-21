#mandatory variables related to name
variable "project_name" {
    type = string
    default = "roboshop"
}

variable "env_name" {
    type = string
    default = "prod"
}

variable "common_tags" {
    default = {
        Project = "roboshop"
        Terraform = true 
        Environment = "prod"
    }
}

variable "tags" {
    default = {
        Component = "cdn"
    }
}

variable "domain_name" {
  default = "devopswitharun.online"
}


