resource "aws_lb_target_group" "app-alb-tg" {
  target_type = "instance"                      #it is default 
  name     = "${local.ec2_name}-${var.tags.Component}"
  protocol = "HTTP"
  port     = 8080
  vpc_id   = data.aws_ssm_parameter.vpc_id.value

  health_check {
    path                = "/"
    port                = 8080
    protocol            = "HTTP"
    healthy_threshold   = 2
    unhealthy_threshold = 3
    interval            = 10
    timeout             = 5
    matcher             = "200-299"
  }
}