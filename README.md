# ACS730-Project2

Terraform

Main "terraform" folder has modular code used for other folders

Terraform component consists of three(3) sub-folders:
1. "vpc" - Network infrastructure; VPC, Subnets, IGW, NAT GW, Route tables and Associations etc.
2. "instances" - All Virtual Machines, Security Groups and SSH key pair
3. "adds" - ALB, Target Group, Launch Template, Auto-Scaling Group

The folders all have "main.tf" file and should be provisioned in the following order
1. "vpc"
2. "instances"
3. "adds"
Any other order will lead to errors

Thye must also be destroyed in the following order:
1. "adds"
2. "instances"
3. "vpc"

Terraform State files stored to S3 bucket - "acs730-project-bucket" 

