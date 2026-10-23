output "azs" {
    value = data.aws_availability_zones.azs.names
}

output "vpc_id" {
  value = aws_vpc.virtual-network.id
}

output "vpc_cidr_block" {
  value = aws_vpc.virtual-network.cidr_block
}

output "nat_gateway_id" {
  value = aws_nat_gateway.nat_gateway.id
}

output "public_subnet_id" {
  value = aws_subnet.public-st[*].id
}

output "private_subnet_id" {
  value = aws_subnet.private-st[*].id
}

output "database_subnet_id" {
  value = aws_subnet.database-st[*].id
}

output "elastic_ip_id" {
  value = aws_eip.elastic.id
}

output "nat_gateway_ids" {
  value = aws_nat_gateway.nat_gateway.id
}

output "public_route_table_id" {
  value = aws_route_table.public-rt.id
}

output "private_route_table_id" {
  value = aws_route_table.private-rt.id
}

output "database_route_table_id" {
  value = aws_route_table.database-rt.id
}
