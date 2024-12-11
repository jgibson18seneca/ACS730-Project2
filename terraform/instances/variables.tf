variable "instance_type" {
  default     = "t2.micro"
  description = "Type of the instance"
  type        = string
}

# Name prefixes
variable "prefix" {
  type        = string
  default     = "prod"
  description = "Name prefix"
}