#VPC
resource "aws_vpc" "virtual-network" {
  cidr_block       = var.vpc_cidr_block
  instance_tenancy = "default"
  enable_dns_hostnames = var.enable_dns_hostnames

  tags = merge(var.common_tags, var.vpc_tags,    
  {
    Name = "${local.resource_name}-vpc"
  })
#here if we have name variables in both tags resource level tags i.e vpc tags dominate the common tags
}

#Internet-GateWay
resource "aws_internet_gateway" "igw" { 
    vpc_id = aws_vpc.virtual-network.id     #this line attaches this igw to custom vpc 

    tags = merge(var.common_tags, var.igw_tags,
    {
        Name = "${local.resource_name}-igw"
    })
  
}   

#Creating 3 Subnets with High availability_Zones 
#public subnet
resource "aws_subnet" "public-st" {
    count = length(var.public_subnet_cidr)

    vpc_id     = aws_vpc.virtual-network.id
    cidr_block = var.public_subnet_cidr[count.index]   
    availability_zone = local.azs_names[count.index]

    tags = merge(var.common_tags, var.public_subnet_tags,
    {
        Name = "${local.resource_name}-public-subnet-${local.azs_names[count.index]}"
    })
}

#private subnet
resource "aws_subnet" "private-st" {
    count = length(var.private_subnet_cidr)

    vpc_id     = aws_vpc.virtual-network.id
    cidr_block = var.private_subnet_cidr[count.index]   
    availability_zone = local.azs_names[count.index]

    tags = merge(var.common_tags, var.private_subnet_tags,
    {
        Name = "${local.resource_name}-private-subnet-${local.azs_names[count.index]}"
    })
}

#database subnet
resource "aws_subnet" "database-st" {
    count = length(var.database_subnet_cidr)

    vpc_id     = aws_vpc.virtual-network.id
    cidr_block = var.database_subnet_cidr[count.index]   
    availability_zone = local.azs_names[count.index]

    tags = merge(var.common_tags, var.database_subnet_tags,
    {
        Name = "${local.resource_name}-database-subnet-${local.azs_names[count.index]}"
    })
}

#database subnet group 
resource "aws_db_subnet_group" "subnet-group" {
  name       = "${local.resource_name}-subnet-group"
  subnet_ids = aws_subnet.database-st[*].id

  tags = merge(var.common_tags, var.database_subnet_group_tags,
    {
        Name = "${local.resource_name}-db-subnet-group"
    })
}


#Create Elastic ip 
resource "aws_eip" "elastic" {
    domain = "vpc"
    #region = local.azs_names[0]

    tags = merge(var.common_tags, var.eip_tags,
    {
        Name = "${local.resource_name}-eip"
    })
}

#NAT gateway 
resource "aws_nat_gateway" "nat_gateway" {
  allocation_id                  = aws_eip.elastic.id
  subnet_id                      = aws_subnet.public-st[0].id     #confusion to check  
  tags = merge(var.common_tags, var.nat_gateway_tags,
    {
        Name = "${local.resource_name}-nat"
    })

    depends_on = [ aws_internet_gateway.igw ]

}

#create route tables for public and private and database subnets 

#public route table 
resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.virtual-network.id 

  tags = merge(var.common_tags, var.public-rt_tags,
    {
        Name = "${local.resource_name}-public-rt"
    })
}

#private route table 
resource "aws_route_table" "private-rt" {
  vpc_id = aws_vpc.virtual-network.id 

  tags = merge(var.common_tags, var.private-rt_tags,
    {
        Name = "${local.resource_name}-private-rt"
    })
}

#database route table 
resource "aws_route_table" "database-rt" {
  vpc_id = aws_vpc.virtual-network.id 

  tags = merge(var.common_tags, var.database-rt_tags,
    {
        Name = "${local.resource_name}-database-rt"
    })
}

#Associating route tables with routes igw and NAT 

#public route adding internet gateway 
resource "aws_route" "public-route" {
    route_table_id = aws_route_table.public-rt.id 
    destination_cidr_block = var.destination_cidr_block
    gateway_id = aws_internet_gateway.igw.id 
}

#private route adding NAT gateway 
resource "aws_route" "private-route" {
    route_table_id = aws_route_table.private-rt.id  
    destination_cidr_block = var.destination_cidr_block
    nat_gateway_id = aws_nat_gateway.nat_gateway.id 
}

#database route adding NAT gateway 
resource "aws_route" "database-route" {
    route_table_id = aws_route_table.database-rt.id  
    destination_cidr_block = var.destination_cidr_block
    nat_gateway_id = aws_nat_gateway.nat_gateway.id 
}

#Associating route tables with subnets 

#Associating public subnets with public route table
resource "aws_route_table_association" "public-subnet-asst" {
  count = length(var.public_subnet_cidr)
  subnet_id      = element(aws_subnet.public-st[*].id, count.index)
  route_table_id = aws_route_table.public-rt.id
}

#Associating private subnets with private route table
resource "aws_route_table_association" "private-subnet-asst" {
  count = length(var.private_subnet_cidr)
  subnet_id      = element(aws_subnet.private-st[*].id, count.index)
  route_table_id = aws_route_table.private-rt.id
}


#Associating database subnets with database route table
resource "aws_route_table_association" "database-subnet-asst" {
  count = length(var.database_subnet_cidr)
  subnet_id      = element(aws_subnet.database-st[*].id, count.index)
  route_table_id = aws_route_table.database-rt.id
}


