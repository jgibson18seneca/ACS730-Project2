provider "aws" {
    region = "us-east-1"
}

// Data block to retrieve VPC ID and Public Subnet IDs
data "terraform_remote_state" "rs_vpc" {
    backend = "s3"
    config = {
        bucket = "acs730-project-bucket"
        key    = "vpc/terraform.tfstate"
        region = "us-east-1"
  }
}

// Data block to recieve Security Group IDs and AMI IDs
data "terraform_remote_state" "rs_instance" {
    backend = "s3"
    config = {
        bucket = "acs730-project-bucket"
        key    = "instances/terraform.tfstate"
        region = "us-east-1"
  }
}

// Load Balancer Target Group
resource "aws_lb_target_group" "proj_tg" {
    name     = "Project TG"
    port     = 80
    protocol = "HTTP"
    vpc_id   = data.terraform_remote_state.rs_vpc.outputs.vpc_id
}

// Load Balancer
resource "aws_lb" "proj_lb" {
    name                = "Project LB"
    internal            = false
    load_balancer_type  = "application"
    security_groups     = [data.terraform_remote_state.rs_instance.outputs.public_sg_id] # Check

    subnet_mapping {
        subnet_id       = data.terraform_remote_state.rs_vpc.outputs.public_subnet_id[0].id
    }
    subnet_mapping {
        subnet_id       = data.terraform_remote_state.rs_vpc.outputs.public_subnet_id[1].id
    }    
    subnet_mapping {
        subnet_id       = data.terraform_remote_state.rs_vpc.outputs.public_subnet_id[2].id
    }
}

// Listener
resource "aws_lb_listener" "proj_list" {
    load_balancer_arn = aws_lb.proj_lb.arn
    port              = "80"
    protocol          = "HTTP"

    default_action {
        type             = "forward"
        target_group_arn = aws_lb_target_group.proj_tg.arn
    }
}

resource "aws_ami_from_instance" "lt_ami" {
  name               = "Webserver AMI"
  source_instance_id = data.terraform_remote_state.rs_instance.outputs.public_VM_ids[1]
}

resource "aws_launch_template" "proj_lt" {
    
    name = "Webserver Image LT"
    instance_type = "t2.micro"
    image_id = aws_ami_from_instance.lt_ami.id
    vpc_security_group_ids = [data.terraform_remote_state.rs_instance.outputs.public_sg_id] //Check
}

resource "aws_placement_group" "proj_pg" {
    name     = "test"
    strategy = "cluster"
}

resource "aws_autoscaling_group" "proj_asg" {
    name                      = "Project ASG"
    max_size                  = 6
    min_size                  = 3
    health_check_grace_period = 300
    health_check_type         = "ELB"
    desired_capacity          = 3
    force_delete              = true
    placement_group           = aws_placement_group.proj_pg.id
    vpc_zone_identifier       = [data.terraform_remote_state.rs_vpc.outputs.public_subnet_id[*]]
    
    instance_maintenance_policy {
        min_healthy_percentage = 90
        max_healthy_percentage = 120
  }
}

resource "aws_autoscaling_group" "proj_asg" {
  availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]
  desired_capacity   = 3
  max_size           = 6
  min_size           = 3

  launch_template {
    id      = aws_launch_template.proj_lt.id
    version = "$Latest"
  }
}