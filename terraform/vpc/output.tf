output "public_subnet_ids" {
  value = module.nonprod_vpc.np_public_subnet_id
}

output "vpc_id" {
  value = module.nonprod_vpc.np_vpc_id
}

output "private_subnet_ids" {
  value = module.nonprod_vpc.np_private_subnet_id
}