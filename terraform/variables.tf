# Name prefixes
variable "prefix" {
  type        = string
  default     = "project"
  description = "Name prefix"
}

# Prod-VPC CIDR range
variable "vpc_cidr" {
  default     = "10.1.0.0/16"
  type        = string
  description = "VPC to host static web site"
}
  
  # Provision public subnets in custom VPC
variable "public_cidrs" {
  default     = ["10.1.1.0/24", "10.1.2.0/24", "10.1.3.0/24", "10.1.4.0/24"]
  type        = list(string)
  description = "Prod Public Subnet CIDRs"
}

variable "private_cidrs" {
  default     = ["10.1.5.0/24", "10.1.6.0/24"]
  type        = list(string)
  description = "Prod Private Subnet CIDRs"
}