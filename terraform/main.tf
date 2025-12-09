###########################################################
# Provider
###########################################################
provider "aws" {
  region = "ap-southeast-2"
}

###########################################################
# Get latest Amazon Linux 2 AMI
###########################################################
data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

###########################################################
# VPC and Subnets
###########################################################
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  name    = "oneclick-vpc"
  cidr    = "10.0.0.0/16"

  azs              = ["ap-southeast-2a", "ap-southeast-2b"]
  public_subnets   = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets  = ["10.0.3.0/24", "10.0.4.0/24"]

  enable_nat_gateway = true
}

###########################################################
# Security Groups
###########################################################
# ALB Security Group
resource "aws_security_group" "alb_sg" {
  name   = "alb_sg"
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 Security Group
resource "aws_security_group" "ec2_sg" {
  name   = "ec2_sg"
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

###########################################################
# Load Balancer
###########################################################
resource "aws_lb" "app_alb" {
  name               = "app-alb"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = module.vpc.public_subnets
}

# Target Group
resource "aws_lb_target_group" "tg" {
  name     = "app-tg"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id

  health_check {
    path = "/health"
    port = "8080"
  }
}

# ALB Listener
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.app_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}

###########################################################
# User Data for EC2
###########################################################
locals {
  userdata = templatefile("${path.module}/../app/userdata.sh", {})
}

###########################################################
# Launch Template
###########################################################
resource "aws_launch_template" "lt" {
  name_prefix   = "oneclick-lt"
  image_id      = data.aws_ami.amazon_linux_2.id
  instance_type = "t3.micro"
  user_data     = base64encode(local.userdata)
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
}

###########################################################
# Auto Scaling Group
###########################################################
resource "aws_autoscaling_group" "asg" {
  desired_capacity     = 2
  max_size             = 2
  min_size             = 2
  vpc_zone_identifier  = module.vpc.private_subnets
  target_group_arns    = [aws_lb_target_group.tg.arn]

  launch_template {
    id      = aws_launch_template.lt.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "oneclick-ec2"
    propagate_at_launch = true
  }
}

