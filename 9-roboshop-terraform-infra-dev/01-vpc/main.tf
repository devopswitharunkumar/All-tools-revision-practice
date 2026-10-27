module "roboshop_vpc" {
    source = "git::https://github.com/devopswitharunkumar/All-tools-revision-practice.git//7-terraform-modules/01-terraform-aws-vpc?ref=main"

    #source = "../../7-terraform-modules/01-terraform-aws-vpc"

    
    #we must mwntion mandatory variables here & remaining optional that is ur choice 
    project_name = var.project_name
    env_name = var.env_name

    #public subnet 
    public_subnet_cidr = var.public_subnet_cidr
    #private subnet 
    private_subnet_cidr = var.private_subnet_cidr
    #database subnet 
    database_subnet_cidr = var.database_subnet_cidr
    database_subnet_group_tags = var.database_subnet_group_tags

    #route association igw and nat 
    destination_cidr_block = var.destination_cidr_block

    #peering related 
    is_peering_required = var.is_peering_required   #u need to give == true == in variables file 
    acceptor_vpc_id = var.acceptor_vpc_id
    
    #All tags related to vpc giving here is optional 
    common_tags = var.common_tags
    vpc_tags = var.vpc_tags
    igw_tags = var.igw_tags
    public_subnet_tags = var.public_subnet_tags
    private_subnet_tags = var.private_subnet_tags
    database_subnet_tags = var.database_subnet_tags
    eip_tags = var.eip_tags
    nat_gateway_tags = var.nat_gateway_tags
    public-rt_tags = var.public-rt_tags
    private-rt_tags = var.private-rt_tags
    database-rt_tags = var.database-rt_tags
    vpc_peering_tags = var.vpc_peering_tags
  
}