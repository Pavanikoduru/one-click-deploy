data "template_file" "user_data" {
  template = file("${path.module}/user_data.tpl")
}

resource "aws_launch_template" "api_lt" {
  name_prefix = "api-lt"
  image_id    = "ami-0e6329e222e662a52"  # Amazon Linux 2 AMI (change if needed)
  instance_type = "t2.micro"

  user_data = base64encode(data.template_file.user_data.rendered)

  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
}

resource "aws_autoscaling_group" "api_asg" {
  vpc_zone_identifier = module.vpc.private_subnets
  launch_template {
    id      = aws_launch_template.api_lt.id
    version = "$Latest"
  }

  desired_capacity = 2
  min_size         = 1
  max_size         = 2

  target_group_arns = [aws_lb_target_group.api_tg.arn]
  health_check_type = "ELB"
}
