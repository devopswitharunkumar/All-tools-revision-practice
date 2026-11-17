## Cloud Front Distribution

resource "aws_cloudfront_distribution" "alb_distribution" {
  enabled         = true
  is_ipv6_enabled = false
  aliases         = ["web-${var.domain_name}.${var.domain_name}"]

  origin {
    domain_name = "web-${var.env_name}.${var.domain_name}"          #we can give APP ALB dns name or web-dev.devopswitharun.online because in that record we have APP_ALB dns name only both are same 
    origin_id   = "web-${var.env_name}.${var.domain_name}"         #data.aws_ssm_parameter.app_alb_id.value       
    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "match-viewer"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }


   # Cache behavior with precedence 0
  ordered_cache_behavior {
    path_pattern     = "/images/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = "web-${var.env_name}.${var.domain_name}"

    cache_policy_id = data.aws_cloudfront_cache_policy.cache_optimized.id

    #by default will be applied for above Managed-CachingOptimized in AWS console see there will default values 
    # min_ttl                = 0
    # default_ttl            = 86400
    # max_ttl                = 31536000
    compress               = true
    viewer_protocol_policy = "https-only"
  }

     # Cache behavior with precedence 1
  ordered_cache_behavior {
    path_pattern     = "/static/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = "web-${var.env_name}.${var.domain_name}"

    cache_policy_id = data.aws_cloudfront_cache_policy.cache_optimized.id

    #by default will be applied for above Managed-CachingOptimized in AWS console see there will default values 
    # min_ttl                = 0
    # default_ttl            = 86400
    # max_ttl                = 31536000
    compress               = true
    viewer_protocol_policy = "https-only"
  }

#default cache behaviour which doesnt cache data every request get dynamic data 
  default_cache_behavior {
    allowed_methods          = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods           = ["GET", "HEAD"]
    target_origin_id         = "web-${var.env_name}.${var.domain_name}"      #data.aws_ssm_parameter.app_alb_id.value
    compress                 = true
    viewer_protocol_policy   = "https-only"
    cache_policy_id          = data.aws_cloudfront_cache_policy.no_cache_optimized.value 
  }


  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["IN", "US", "CA"]
    }
  }

  viewer_certificate {
    acm_certificate_arn = data.aws_ssm_parameter.acm_cert_arn.value
    ssl_support_method  = "sni-only"
  }
}



resource "aws_route53_record" "app_alb_alias" {
  zone_id = data.aws_route53_zone.domain_zone_id.id

  name = "web-${var.tags.Component}.${var.domain_name}"
  type = "A"

  alias {
    name                   = aws_cloudfront_distribution.alb_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.alb_distribution.hosted_zone_id
    evaluate_target_health = true
  }
}