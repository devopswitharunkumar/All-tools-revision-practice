#string type 

variable "ami" {
    type = string
    default = "ami-0220d79f3f480ecf5"
}
#list type
variable "instance_type" {
    type = list
    default = [ "t2.small", "t2.micro"]
}

#int type 
variable "from_port" {
    type = number
    default = 0
}

#map type
variable "tags_details" {
    type = map(string)
    default = {
        Name = "ec2-with-variables"
        terraform = true                #boolean type
        env = "Dev"
    }
}
