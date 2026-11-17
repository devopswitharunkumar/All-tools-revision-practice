variable "ami" {
    type = string
    default = "ami-0220d79f3f480ecf5"
}

variable "instance_names" {
    type = map(string)
    default = {
        mongodb = "t3.small"
        redis = "t3.micro"
        mysql = "t3.small"
        rabbitmq = "t3.micro"
        catalogue = "t3.micro"
        cart = "t3.micro"
        user = "t3.micro"
        shipping = "t3.small"
        payment = "t3.micro"
        web = "t3.micro"
        dispatch = "t3.micro"
    }
}

variable "Zone_id" {
    type = string
    default = "Z02149386QBAC23T25TA"
}

variable "Domain_name" {
    type = string
    default = "devopswitharun.online"
}