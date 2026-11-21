variable "project_name" {
  default = "roboshop"
}

variable "env_name" {
  default = "prod"
}

variable "vpc_cidr_block" {
  type = string
  default = "10.1.0.0/16"
}

variable "enable_dns_hostnames" {
  type = bool
  default = true
}

#public subnet related
variable "public_subnet_cidr" {
    default = ["10.1.1.0/24", "10.1.2.0/24"]
}

#private subnet related
variable "private_subnet_cidr" {
    default = ["10.1.11.0/24", "10.1.12.0/24"]
}

#database subnet related
variable "database_subnet_cidr" {
    default = ["10.1.21.0/24", "10.1.22.0/24"]
}

#adding routes internet gtw for public rt and NAT gateway for private and database route tables 
variable "destination_cidr_block" {
    default = "0.0.0.0/0"
}



#VPC peering related 
#peering related 
variable "is_peering_required" {
    type = bool 
    default = true      #if u want peering u need to override as ===> false 
}

variable "acceptor_vpc_id" {
    type = string
    default = ""
}

variable "vpc_peering_tags" {
    default = {
        Project = "roboshop-prod-vpc-peering"
        Terraform = true 
        Environment = "prod"
    } 
}

#VPC relates variables 
variable "common_tags" {
    default = {
        Project = "roboshop"
        Terraform = true 
        Environment = "prod"
    }
}

variable "vpc_tags" {
    default = {
        Project = "roboshop-prod-vpc"
        Terraform = true 
        Environment = "prod"
    }
}

variable "igw_tags" {
    default = {
        Project = "roboshop-prod-igw"
        Terraform = true 
        Environment = "prod"
    }
}


variable "public_subnet_tags" {
    default = {
        Project = "roboshop-prod-public-subnet"
        Terraform = true 
        Environment = "prod"
    }
}
variable "private_subnet_tags" {
    default = {
        Project = "roboshop-prod-private-subnet"
        Terraform = true 
        Environment = "prod"
    }
}

variable "database_subnet_tags" {
    default = {
        Project = "roboshop-prod-database-subnet"
        Terraform = true 
        Environment = "prod"
    }
}

variable "database_subnet_group_tags" {
    default = {
        Project = "roboshop-prod-database-subnet-group"
        Terraform = true 
        Environment = "prod"
    }
}

#elastic ip related 
variable "eip_tags" {
    default = {
        Project = "roboshop-prod-eip"
        Terraform = true 
        Environment = "prod"
    }
}

#nat-gateway related 
variable "nat_gateway_tags" {
    default = {
        Project = "roboshop-prod-nat-gateway"
        Terraform = true 
        Environment = "prod"
    }
}

#public route table related
variable "public-rt_tags" {
    default = {
        Project = "roboshop-prod-public-rt"
        Terraform = true 
        Environment = "prod"
    }
}

#private route table related
variable "private-rt_tags" {
    default = {
        Project = "roboshop-prod-private-rt"
        Terraform = true 
        Environment = "prod"
    }
}

#database route table related
variable "database-rt_tags" {
    default = {
        Project = "roboshop-prod-database-rt"
        Terraform = true 
        Environment = "prod"
    }
}