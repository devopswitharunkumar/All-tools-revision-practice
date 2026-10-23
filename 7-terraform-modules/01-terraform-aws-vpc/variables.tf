#mandatory variables related to name
variable "project_name" {
    type = string
}

variable "env_name" {
    type = string
}

#vpc variables 
variable "vpc_cidr_block" {
    type = string
    default = "10.0.0.0/16"     #users can override 
}

variable "enable_dns_hostnames" {
    type = bool 
    default = true
}

variable "common_tags" {
    type = map 
    default = {}
}

variable "vpc_tags" {
    type = map 
    default = {}
}

#internet gateway variables 
variable "igw_tags" {
    type = map 
    default = {}
}

#public Subnets related
variable "public_subnet_cidr" {
    type = list
    validation {
        condition = length(var.public_subnet_cidr) == 2
        error_message = "Pls give 2 public valid subnet CIDR id's"
            #if we give more than 2 cidr ip's in list it will throw error 
    }
}

variable "public_subnet_tags" {
    type = map 
    default = {}
}

#private subnet related
variable "private_subnet_cidr" {
    type = list
    validation {
        condition = length(var.private_subnet_cidr) == 2
        error_message = "Pls give 2 private valid subnet CIDR id's"
    #if we give more than 2 cidr ip's in list it will throw error 
    }
}

variable "private_subnet_tags" {
    type = map 
    default = {}
}

#database subnet related
variable "database_subnet_cidr" {
    type = list
    validation {
        condition = length(var.database_subnet_cidr) == 2
        error_message = "Pls give 2 database valid subnet CIDR id's"
    #if we give more than 2 cidr ip's in list it will throw error 
    }
}

variable "database_subnet_tags" {
    type = map 
    default = {}
}

variable "database_subnet_group_tags" {
  type = map 
  default = {}
}

#elastic ip related
variable "eip_tags" {
    default = {}
}

#nat related
variable "nat_gateway_tags" {
    default = {}
}

#route tables related 
#public route table
variable "public-rt_tags" {
  default = {}
}

#private route table
variable "private-rt_tags" {
  default = {}
}

#database route table
variable "database-rt_tags" {
  default = {}
}

variable "destination_cidr_block" {
  type = string
  default = "0.0.0.0/0"
}


#peering related 
variable "is_peering_required" {
    type = bool 
    default = false 
}

variable "acceptor_vpc_id" {
    type = string
    default = ""
}

variable "vpc_peering_tags" {
  type = map 
  default = {}
}