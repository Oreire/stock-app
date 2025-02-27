# Create Application Load Balancer
resource "aws_lb" "stock_alb" {
  name               = "STOCK-ALB"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.stock_sg.id]
  subnets            = aws_subnet.stock_subnet[*].id

  tags = {
    Name = "STOCK-ALB"
  }
}

# Create Target Group
resource "aws_lb_target_group" "stock_tg" {
  name     = "STOCK-TG"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.stock_vpc.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }

  tags = {
    Name = "STOCK-TG"
  }
}

# Create Listener
resource "aws_lb_listener" "stock_listener" {
  load_balancer_arn = aws_lb.stock_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.stock_tg.arn
  }
}


