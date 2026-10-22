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

variable "egress_description" {
  default = "Allow all for outgoing traffic"
}


variable "dynamic_blocks" {
  
default =  [
    {
        description = "Allow all for 22 incomming traffic" 
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    },
    {
        description = "Allow all for 0 incomming traffic" 
        from_port = 0
        to_port = 0
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    },
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