# ACS730-Project2

Terraform

Main "terraform" folder has modular code used for other folders

Terraform component consists of three(3) sub-folders, each have a "main.tf" file and should be provisioned in the following order :
1. "vpc" - Network infrastructure; VPC, Subnets, IGW, NAT GW, Route tables and Associations etc.
2. "instances" - All Virtual Machines, Security Groups and SSH key pair
3. "adds" - ALB, Target Group, Launch Template, Auto-Scaling Group
Any other order will lead to errors
After the creation of the items in part three, the instances would need to be added to the target group due to the coding used.

They must also be destroyed in the following order:
1. "adds"
2. "instances"
3. "vpc"

******* OTHER NOTES *******
Terraform State files stored to S3 bucket - "acs730-project-bucket"
SSH Key Pair needs to be created before provisioning "instances" folder - Key Pair should be named 'project'

