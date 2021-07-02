
# Shared LB that is used for all the apps
resource "aws_alb" "shared_load_balancer" {
  name               = "test-lb-tf"
  load_balancer_type = "application"
  subnets = [
    aws_subnet.subnet_a.id,
    aws_subnet.subnet_b.id
  ]

  security_groups = [aws_security_group.load_balancer_security_group.id]
}

# Allow ALB access from anywhere
resource "aws_security_group" "load_balancer_security_group" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allowing from anywhere
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Default listener for non-matched domains
resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_alb.shared_load_balancer.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "You hit the ALB!"
      status_code  = "403"
    }
  }
}
