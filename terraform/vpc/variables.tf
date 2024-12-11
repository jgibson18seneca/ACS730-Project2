# Name prefixes
variable "npprefix" {
  type        = string
  default     = "non-prod"
  description = "Name prefix"
}

# Nonprod-VPC CIDR range
variable "np_vpc_cidr" {
  default     = "10.1.0.0/16"
  type        = string
  description = "VPC to host static web site"
}
  
  # Provision public subnets in custom VPC
variable "np_public_cidrs" {
  default     = ["10.1.1.0/24", "10.1.2.0/24"]
  type        = list(string)
  description = "on-prod Public Subnet CIDRs"
}

variable "np_private_cidrs" {
  default     = ["10.1.3.0/24", "10.1.4.0/24"]
  type        = list(string)
  description = "Non-prod Private Subnet CIDRs"
}