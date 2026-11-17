variable "ami" {
    type = string
    default = "ami-0220d79f3f480ecf5"
}

variable "instance_names" {
    type = list
    default = ["mongodb", "redis", "mysql", "rabbitmq", "catalogue", "cart", "user", "shipping", "payment", "web", "dispatch"]
}


variable "instance_type" {
  default = "t2.micro"
}


variable "Zone_id" {
    type = string
    default = "Z02149386QBAC23T25TA"
}

variable "Domain_name" {
    type = string
    default = "devopswitharun.online"
}


variable "proj_name" {
  default = "roboshop"
}


variable "env_name" {
  default = "dev"
}


variable "servers" {
  default = {
    web = "t3.micro",
    mysql = "t3.small",
    redis = "t3.medium",
    mongodb = "t3.large",
    cart = "t3.xlarge",
  }
}
