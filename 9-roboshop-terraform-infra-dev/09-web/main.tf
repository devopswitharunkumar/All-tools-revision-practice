resource "aws_lb_target_group" "web-alb-tg" {
  name        = "${local.ec2_name}-${var.tags.Component}-tg"
  target_type = "instance"
  port        = 80
  protocol    = "HTTPS"
  vpc_id      = data.aws_ssm_parameter.vpc_id.value

  # Health Check Configuration Block
  health_check {
    path                = "/health"
    port                = 80
    protocol            = "HTTPS"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 3
    matcher             = "200-299"
  }

}


resource "aws_lb_listener_rule" "host_based_weighted_routing" {
  listener_arn = aws_lb_listener.https_listner.arn
  priority     = 1

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web-alb-tg.arn
  }

  condition {
    host_header {
      values = "web-${var.domain_name}"
    }
  }
}