locals {
  ec2_name = "${var.project_name}-${var.env_name}"
  database_subnet_ids = element(split(",", data.aws_ssm_parameter.database_subnet_id.value),0)
}


locals {
  dns_records = {
    mongodb = module.mongodb.private_ip
    redis     = module.redis.private_ip
    mysql     = module.mysql.private_ip
    rabbitmq  = module.rabbitmq.private_ip
  }
}