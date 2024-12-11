provider "aws" {
  region = "us-east-1"
}

data "aws_ami" "latest_amazon_linux" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

data "terraform_remote_state" "project" { // This is to use Outputs from Remote State
  backend = "s3"
  config = {
    bucket = "acs730-project-bucket"             // Bucket from where to GET Terraform State
    key    = "vpc/terraform.tfstate" // Object name in the bucket to GET Terraform State
    region = "us-east-1"                           // Region where bucket created
  }
}

resource "aws_instance" "public_vw" {
  count                       = length(data.terraform_remote_state.project.outputs.public_subnet_id[*])
  ami                         = data.aws_ami.latest_amazon_linux.id
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.project.key_name
  subnet_id                   = data.terraform_remote_state.project.outputs.public_subnet_id[1]
  security_groups             = [aws_security_group.public_sg.id]
  associate_public_ip_address = true
    tags =    {
      Name = "Webserver-${count.index + 1}"
    }
}

resource "aws_instance" "private_VM" {
  count                       = length(data.terraform_remote_state.project.outputs.private_subnet_id[*])
  ami                         = data.aws_ami.latest_amazon_linux.id
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.project.key_name
  subnet_id                   = data.terraform_remote_state.project.outputs.private_subnet_id[count.index]
  security_groups             = [aws_security_group.private_sg.id]
  associate_public_ip_address = true
    tags =    {
      Name = "Webserver-${count.index + 5}"
    }
}

resource "aws_key_pair" "project" {
  key_name   = "project"
  public_key = file("project.pub")
}

# Public Security Group
resource "aws_security_group" "public_sg" {
  name        = "public_sg"
  description = "Allow HTTP and SSH inbound traffic"
  vpc_id      = data.terraform_remote_state.project.outputs.vpc_id

  ingress {
    description      = "HTTP from everywhere"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "SSH from everywhere"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  
    ingress {
    description      = "ICMP within VPC"
    from_port        = 8
    to_port          = 0
    protocol         = "icmp"
    cidr_blocks      = ["10.1.0.0/16"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags =    {
      Name = "public-sg"
    }
}

# Private Security Group
resource "aws_security_group" "private_sg" {
  name        = "private_sg"
  description = "Allow ICMP and SSH inbound traffic"
  vpc_id      = data.terraform_remote_state.project.outputs.vpc_id

  ingress {
    description      = "ICMP within VPC"
    from_port        = 8
    to_port          = 0
    protocol         = "icmp"
    cidr_blocks      = ["10.1.0.0/16"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "SSH from everywhere"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  
  tags =    {
      Name = "private-sg}"
    }
}