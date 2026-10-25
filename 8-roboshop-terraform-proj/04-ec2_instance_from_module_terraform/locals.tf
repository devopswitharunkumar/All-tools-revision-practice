locals {
  ec2_name = "${var.project_name}-${var.env_name}"
  database_subnet_ids = element(split(",", data.aws_ssm_parameter.database_subnet_id.value),0)
  private_subnet_ids = element(split(",", data.aws_ssm_parameter.private_subnet_id.value),0)
  public_subnet_ids = element(split(",", data.aws_ssm_parameter.public_subnet_id.value),0)
}


locals {
  dns_records = {
    mongodb = module.mongodb.private_ip
    redis     = module.redis.private_ip
    mysql     = module.mysql.private_ip
    rabbitmq  = module.rabbitmq.private_ip
    catalogue = module.catalogue.private_ip
    user      = module.user.private_ip
    cart      = module.cart.private_ip
    shipping  = module.shipping.private_ip
    payment   = module.payment.private_ip
    web       = module.web.private_ip
  }
}