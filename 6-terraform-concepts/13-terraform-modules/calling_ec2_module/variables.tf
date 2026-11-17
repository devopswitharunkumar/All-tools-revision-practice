variable "instance_type" {
  default = "t3.micro"
}

variable "tags" {
    type = map(string)
    default = {
        Name = "ec2-calling in root module"
        terraform = true 
        env = "Dev"
    }
}