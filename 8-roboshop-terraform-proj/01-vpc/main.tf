module "roboshop_vpc" {
    # source = "git::https://github.com/devopswitharunkumar/All-tools-revision-practice.git//7-terraform-modules/01-terraform-aws-vpc?ref=main"
    source = "../../7-terraform-modules/01-terraform-aws-vpc"
    project_name = var.project_name
    env_name = var.env_name
    common_tags = var.common_tags
    vpc_tags = var.vpc_tags

    #public subnet 
    public_subnet_cidr = var.public_subnet_cidr
    #private subnet 
    private_subnet_cidr = var.private_subnet_cidr
    #database subnet 
    database_subnet_cidr = var.database_subnet_cidr

    destination_cidr_block = var.destination_cidr_block

    #peering related 
    is_peering_required = var.is_peering_required   #u need to give == true == in variables file 

  
}