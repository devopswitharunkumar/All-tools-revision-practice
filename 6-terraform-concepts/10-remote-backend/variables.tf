variable "env" {
    type = string
    default = "dev"
}

variable "tags_details" {
    type = map(string)
    default = {
        Name = "ec2-with-variables"
        terraform = true               
        env = "Dev"
    }
}