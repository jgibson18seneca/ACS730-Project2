output "vpc_id" {
  value = aws_vpc.prod.id
}

output "internet_gateway" {
  value = aws_internet_gateway.internet_gateway.id
}

output "public_subnet_id" {
  value = aws_subnet.prod_public_subnet[*].id
}

output "private_subnet_id" {
  value = aws_subnet.prod_private_subnet[*].id
}

output "public_rt_id" {
    value = aws_route_table.prod_public_rt.id
}

output "private_rt_id" {
    value = aws_route_table.prod_private_rt.id
}

output "nat_gatway_id" {
  value = aws_nat_gateway.nat_gateway.id
}