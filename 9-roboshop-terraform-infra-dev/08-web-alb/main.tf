resource "aws_lb" "web-alb" {
  name               = "${local.ec2_name}-${var.tags.Component}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = data.aws_ssm_parameter.web_alb_sg_id.value 
  subnets            = split(",",data.aws_ssm_parameter.public_subnet_id.value)

    tags = merge(var.common_tags, var.tags, 
    {
        Name = "${local.ec2_name}-${var.tags.Component}"
    })
}


resource "aws_lb_listener" "https_listner" {
  load_balancer_arn = aws_lb.web-alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-Res-PQ-2025-09"
  certificate_arn   = data.aws_ssm_parameter.acm_cert_arn.value

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Hi, This is from WEB ALB"
      status_code  = "200-299"      #or 200 we can give or others b/w because success means 200-299
    }
  }
}

resource "aws_route53_record" "web-alb-route" {
  zone_id = data.aws_route53_zone.zone_id.id
  name    = "web-${var.env_name}.${var.domain_name}"
  type    = "A"

  alias {
    name                   = aws_lb.web-alb.dns_name        #web alb dns name 
    zone_id                = aws_lb.web-alb.zone_id         #web alb zone id not our domain zone id 
    evaluate_target_health = true
  }
}



