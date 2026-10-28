#mandatory variables related to name
variable "project_name" {
    type = string
    default = "roboshop"
}

variable "env_name" {
    type = string
    default = "dev"
}

variable "common_tags" {
    default = {
        Project = "roboshop"
        Terraform = true 
        Environment = "dev"
    }
}

variable "tags" {
    default = {
        Component = "web"
    }
}