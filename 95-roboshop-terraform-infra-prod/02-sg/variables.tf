variable "project_name" {
  type = string
  default = "roboshop"
}
variable "env_name" {
  type = string
  default = "prod"
}

#VPC relates variables 
variable "common_tags" {
    default = {
        Project = "roboshop"
        Terraform = true 
        Environment = "prod"
    }
}

variable "mongodb_sg_ingress_rules" {
  default = [
     {
        description = "Allow all for 80 incomming traffic" 
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    },
    {        
        description = "Allow all for 443 incomming traffic" 
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}