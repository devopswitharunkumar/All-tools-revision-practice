#mandatory variables related to name
variable "project_name" {
    type = string
}

variable "env_name" {
    type = string
}
variable "sg_name" {
    type = string
}

variable "sg_description" {
    type = string
}

#until above all are mandatory variables 

#not mandatory 
variable "sg_tags" {
    type = map 
  default = {}
}
variable "common_tags" {
    type = map 
  default = {}
}

variable "vpc_id" {
    type = string
    default = {}
}

variable "sg_ingress_rules" {
  type = list 
  default = []
}