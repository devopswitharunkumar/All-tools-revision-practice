variable "instance_type" {
  default = "t2.micro"
}

variable "tags" {
  default = {
    name = "roboshop-dev"
    env = "dev"
    terraform = true 
    remoteexec = true
  }
}

variable "sg_name" {
  default = "remote-sg"
}

variable "description" {
  default = "security group for remote exec"
}