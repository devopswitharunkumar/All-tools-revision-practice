variable "instance_type" {
   type = list(string)
   default = [ "mongodb", "redis", "mysql", "rabbitmq", "catalogue", "cart", "user", "shipping", "payment", "web", "dispatch"]
}

variable "proj_name" {
  default = "roboshop"
}

variable "env_name" {
  default = "dev"
}

variable "Domain_name" {
    type = string
    default = "devopswitharun.online"
}


#or 
# variable "instance_names" {
  
# }

