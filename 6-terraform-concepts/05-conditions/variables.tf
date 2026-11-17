variable "ami" {
    type = string
    default = "ami-0220d79f3f480ecf5"
}

variable "env" {
    type = string
    default = "dev"
}

variable "tags_details" {
    type = map(string)
    default = {
        Name = "ec2-with-variables"
        terraform = true                #boolean type
        env = "Dev"
    }
}