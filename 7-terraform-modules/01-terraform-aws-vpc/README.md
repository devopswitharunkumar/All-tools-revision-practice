### AWS VPC module 

This module creates following resources. We are using HA, we are getting first 2 AZ
automatically.
* VPC
* Internet Gateway with VPC association
* 2 Private subnets in 1a and 1b
* 2 Database subnets in 1a and 1b
* NAT gateway in 1a public subnet
* Public Route Table
* Private Route Table
* Database Route Table
* Subnets and Route table associations

### Peering related
* VPC peering if user requests
* Adding the peering route in default VPC, if user don't provide acceptor VPC explicitly. if user  provides Acceptor vpc we need to add in that
* Adding the peering routes in public, private and database route tables from Requestor VPC


### Inputs 
* project_name (Required) - your project name
* env_name (Required) - which environment you are working on 
* vpc_cidr_block (Optional) - Default value is 10.0.0.0/16, user can override
* enable_dns_hostnames (Optional) - Default value is true

* common_tags (Optional) - Better to provide
* vpc_tags (Optional) - Default value is empty. type is map
* igw_tags (Optional) - Default value is empty. type is map

* public_subnet_cidr (Required) - User must provide 2 valid public subnets CIDR
* public_subnet_tags (Optional) - Default value is empty. type is map
* prvate_subnet_cidr (Required) - User must provide 2 valid private subnets CIDR
* private_subnet_tags (Optional) - Default value is empty. type is map
* database_subnet_cidr (Required) - User must provide 2 valid database subnets CIDR
* database_subnet_tags (Optional) - Default value is empty. type is map
* database_subnet_group_tags (Optional) - Default value is empty. type is map

* eip_tags (Optional) - Default value is empty. type is map
* nat_gateway_tags (Optional) - Default value is empty. type is map

* public_route_table_tags (Optional) - Default value is empty. type is map
* private_route_table_tags (Optional) - Default value is empty. type is map
* database_route_table_tags (Optional) - Default value is empty. type is map

* destination_cidr_block  (Optional) - Default value provided but users can override

### VPC related inputs 
* is_peering_required (Optional) - default value is false
* acceptor_vpc_id (Optional) - default value is default VPC ID 
* vpc_peering_tags (Optional) - Default value is empty. type is map

### outputs -- All id's of created resources are available through outputs 