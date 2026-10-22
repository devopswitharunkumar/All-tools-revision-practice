variable "ami" {
    type = string
    default = "ami-0220d79f3f480ecf5"
}

variable "instance_type" {
    type = string
    default = "t2.micro"
}

variable "tags_details" {
    type = map(string)
    default = {
        Name = "ec2-with-variables"
        terraform = true 
        env = "Dev"
    }
}

variable "from_port" {
    type = number
    default = 0
}

variable "to_port" {
  default = "0"
}

variable "protocol" {
  default = "-1"
}

variable "cidr" {
    type = list 
  default = ["0.0.0.0/0"]
}

variable "ingress_description" {
  default = "Allow all for incomming traffic"
}

variable "egress_description" {
  default = "Allow all for outgoing traffic"
}