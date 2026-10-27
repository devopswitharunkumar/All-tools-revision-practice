resource "aws_lb" "app_alb" {
  name               = "${local.ec2_name}-${var.tags.Component}"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [ data.aws_ssm_parameter.app_alb_sg_id.value ]
  subnets            = split(",", data.aws_ssm_parameter.private_subnet_id.value)

  enable_deletion_protection = false  
  #it should be there but after practice we need to destroy so we kept false, true means cannot delete

   tags = merge(var.common_tags, var.tags, 
    {
        Name = "${local.ec2_name}-${var.tags.Component}"
    })
}

resource "aws_lb_listener" "http_listner" {
  load_balancer_arn = aws_lb.app_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type      = "text/plain"
      message_body      = "Hi, This response from APP_ALB"
      status_code       = "200"
    }
  }
}


resource "aws_route53_record" "app-alb-record" {
  zone_id = data.aws_route53_zone.zone_id.id
  name    = "*.app-${var.env_name}.${var.domain_name}"
  type    = "A"

  alias {
    name                   = aws_lb.app_alb.dns_name
    zone_id                = aws_lb.app_alb.zone_id         #load balancer zone id
    evaluate_target_health = true
  }
}
