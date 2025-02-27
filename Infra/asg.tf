/* # Launch Configuration for Auto Scaling
resource "aws_launch_configuration" "stock_lc" {
  name          = "stock-lc"
  image_id      = "ami-00710ab5544b60cf7"
  instance_type = "t2.micro"
  security_groups = [aws_security_group.stock_sg.id]
  key_name      = "Ans-Auth"

  lifecycle {
    create_before_destroy = true
  }

  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install -y httpd
    systemctl start httpd
    systemctl enable httpd
  EOF
}

# Auto Scaling Group
resource "aws_autoscaling_group" "stock_asg" {
  desired_capacity     = 2
  max_size             = 5
  min_size             = 1
  vpc_zone_identifier  = aws_subnet.stock_subnet[*].id
  launch_configuration = aws_launch_configuration.stock_lc.id
  target_group_arns    = [aws_lb_target_group.stock_tg.arn]

  tag {
    key                 = "Name"
    value               = "STOCK-ASG"
    propagate_at_launch = true
  }
} */