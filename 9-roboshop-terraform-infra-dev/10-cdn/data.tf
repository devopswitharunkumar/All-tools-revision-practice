data "aws_ssm_parameter" "app_alb_id" {
    name = "/${var.project_name}/${var.env_name}/app_alb_id"
}



# Look up the ID of the AWS managed CachingOptimized policy
data "aws_cloudfront_cache_policy" "cache_optimized" {
  name = "Managed-CachingOptimized"                          #we can define how many days cached data should store
}

# Look up the ID of the AWS managed CachingOptimized policy
data "aws_cloudfront_cache_policy" "no_cache_optimized" {
  name = "Managed-CachingDisabled"                                   #it will not store cached data  
}

data "aws_ssm_parameter" "acm_cert_arn" {
    name = "/${var.project_name}/${var.env_name}/acm_cert_arn"
}

data "aws_route53_zone" "domain_zone_id" {
  name         = var.domain_name
  private_zone = false
}