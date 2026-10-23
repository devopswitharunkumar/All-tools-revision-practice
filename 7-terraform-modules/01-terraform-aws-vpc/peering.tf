resource "aws_vpc_peering_connection" "peering" {
    count = var.is_peering_required ? 1 : 0 

    vpc_id        = aws_vpc.virtual-network.id        #id of requestor VPC 
    
    #target VPC that is Acceptor VPC details 
    # peer_owner_id = var.peer_owner_id                       #Account id of target Acceptor VPC if other account 
    # peer_region = var.peer_region                           #region of target Acceptor VPC if other account 

    #refer document for other options 

    #vpc id of target Acceptor VPC 
    peer_vpc_id   = var.acceptor_vpc_id == "" ? data.aws_vpc.default_vpc.id : var.acceptor_vpc_id        
    auto_accept = data.aws_vpc.default_vpc.default == true ? true : false 

    tags = merge(var.common_tags, var.vpc_peering_tags,
    {
        Name = "${local.resource_name}-peering"
    })
}

resource "aws_route" "acceptor_vpc_route" {
    count = var.is_peering_required && var.acceptor_vpc_id == "" ? 1 : 0
    route_table_id = data.aws_route_table.default_rt.id 
    destination_cidr_block = var.vpc_cidr_block
    vpc_peering_connection_id = aws_vpc_peering_connection.peering[0].id
}

#public route adding internet gateway 
resource "aws_route" "public-rt" {
    count = var.is_peering_required && var.acceptor_vpc_id == "" ? 1 : 0
    route_table_id = aws_route_table.public-rt.id 
    destination_cidr_block = data.aws_vpc.default_vpc.cidr_block
    vpc_peering_connection_id = aws_vpc_peering_connection.peering[0].id

}

#private route adding NAT gateway 
resource "aws_route" "private-rt" {
    count = var.is_peering_required && var.acceptor_vpc_id == "" ? 1 : 0
    route_table_id = aws_route_table.private-rt.id  
    destination_cidr_block = data.aws_vpc.default_vpc.cidr_block
    vpc_peering_connection_id = aws_vpc_peering_connection.peering[0].id
}

#database route adding NAT gateway 
resource "aws_route" "database-rt" {
    count = var.is_peering_required && var.acceptor_vpc_id == "" ? 1 : 0
    route_table_id = aws_route_table.database-rt.id  
    destination_cidr_block = data.aws_vpc.default_vpc.cidr_block
    vpc_peering_connection_id = aws_vpc_peering_connection.peering[0].id
}




