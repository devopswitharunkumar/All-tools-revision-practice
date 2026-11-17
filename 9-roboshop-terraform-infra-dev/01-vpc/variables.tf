variable "project_name" {
  default = "roboshop"
}

variable "env_name" {
  default = "dev"
}

variable "vpc_cidr_block" {
  type = string
  default = "10.0.0.0/16"
}

variable "enable_dns_hostnames" {
  type = bool
  default = true
}

#public subnet related
variable "public_subnet_cidr" {
    default = ["10.0.1.0/24", "10.0.2.0/24"]
}

#private subnet related
variable "private_subnet_cidr" {
    default = ["10.0.11.0/24", "10.0.12.0/24"]
}

#database subnet related
variable "database_subnet_cidr" {
    default = ["10.0.21.0/24", "10.0.22.0/24"]
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
        Project = "roboshop-dev-vpc-peering"
        Terraform = true 
        Environment = "dev"
    } 
}

#VPC relates variables 
variable "common_tags" {
    default = {
        Project = "roboshop"
        Terraform = true 
        Environment = "dev"
    }
}

variable "vpc_tags" {
    default = {
        Project = "roboshop-dev-vpc"
        Terraform = true 
        Environment = "dev"
    }
}

variable "igw_tags" {
    default = {
        Project = "roboshop-dev-igw"
        Terraform = true 
        Environment = "dev"
    }
}


variable "public_subnet_tags" {
    default = {
        Project = "roboshop-dev-public-subnet"
        Terraform = true 
        Environment = "dev"
    }
}
variable "private_subnet_tags" {
    default = {
        Project = "roboshop-dev-private-subnet"
        Terraform = true 
        Environment = "dev"
    }
}

variable "database_subnet_tags" {
    default = {
        Project = "roboshop-dev-database-subnet"
        Terraform = true 
        Environment = "dev"
    }
}

variable "database_subnet_group_tags" {
    default = {
        Project = "roboshop-dev-database-subnet-group"
        Terraform = true 
        Environment = "dev"
    }
}

#elastic ip related 
variable "eip_tags" {
    default = {
        Project = "roboshop-dev-eip"
        Terraform = true 
        Environment = "dev"
    }
}

#nat-gateway related 
variable "nat_gateway_tags" {
    default = {
        Project = "roboshop-dev-nat-gateway"
        Terraform = true 
        Environment = "dev"
    }
}

#public route table related
variable "public-rt_tags" {
    default = {
        Project = "roboshop-dev-public-rt"
        Terraform = true 
        Environment = "dev"
    }
}

#private route table related
variable "private-rt_tags" {
    default = {
        Project = "roboshop-dev-private-rt"
        Terraform = true 
        Environment = "dev"
    }
}

#database route table related
variable "database-rt_tags" {
    default = {
        Project = "roboshop-dev-database-rt"
        Terraform = true 
        Environment = "dev"
    }
}