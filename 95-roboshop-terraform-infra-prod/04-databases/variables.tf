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

variable "mongodb_tags" {
    type = map 
    default = {}
}

variable "instance_type" {
    type = string
    default = "t2.micro"
}

variable "domain_name" {
    type = string
    default = "devopswitharun.online"
}

