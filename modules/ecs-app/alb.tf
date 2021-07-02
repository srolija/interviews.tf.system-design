
resource "aws_lb_target_group" "target_group" {
  name        = var.app_name
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id
}

# Add listener for the specific domain
resource "aws_lb_listener_rule" "application" {
  listener_arn = var.alb_listener_arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }

  condition {
    host_header {
      values = [var.domain]
    }
  }
}
