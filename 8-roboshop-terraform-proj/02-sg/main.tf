module "vpn" {
    # source = "git::https://github.com/devopswitharunkumar/All-tools-revision-practice.git//7-terraform-modules/03-terraform-aws-sg?ref=main"
    source = "../../7-terraform-modules/03-terraform-aws-sg"
    project_name = var.project_name
    env_name = var.env_name
    vpc_id = data.aws_vpc.default_vpc_id.id
    sg_name = "vpn"
    sg_description = "SG for vpn"
    #sg_ingress_rules = var.vpn_sg_ingress_rules
}

module "mongodb" {
    # source = "git::https://github.com/devopswitharunkumar/All-tools-revision-practice.git//7-terraform-modules/03-terraform-aws-sg?ref=main"
    source = "../../7-terraform-modules/03-terraform-aws-sg"
    project_name = var.project_name
    env_name = var.env_name
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    sg_name = "mongodb"
    sg_description = "SG for mongodb"
    #sg_ingress_rules = var.mongodb_sg_ingress_rules
}

module "redis" {
    # source = "git::https://github.com/devopswitharunkumar/All-tools-revision-practice.git//7-terraform-modules/03-terraform-aws-sg?ref=main"
    source = "../../7-terraform-modules/03-terraform-aws-sg"
    project_name = var.project_name
    env_name = var.env_name
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    sg_name = "redis"
    sg_description = "SG for redis"
    #sg_ingress_rules = var.mongodb_sg_ingress_rules
}

module "mysql" {
    # source = "git::https://github.com/devopswitharunkumar/All-tools-revision-practice.git//7-terraform-modules/03-terraform-aws-sg?ref=main"
    source = "../../7-terraform-modules/03-terraform-aws-sg"
    project_name = var.project_name
    env_name = var.env_name
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    sg_name = "mysql"
    sg_description = "SG for mysql"
    #sg_ingress_rules = var.mongodb_sg_ingress_rules
}

module "rabbitmq" {
    # source = "git::https://github.com/devopswitharunkumar/All-tools-revision-practice.git//7-terraform-modules/03-terraform-aws-sg?ref=main"
    source = "../../7-terraform-modules/03-terraform-aws-sg"
    project_name = var.project_name
    env_name = var.env_name
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    sg_name = "rabbitmq"
    sg_description = "SG for rabbitmq"
    #sg_ingress_rules = var.mongodb_sg_ingress_rules
}

module "catalogue" {
    # source = "git::https://github.com/devopswitharunkumar/All-tools-revision-practice.git//7-terraform-modules/03-terraform-aws-sg?ref=main"
    source = "../../7-terraform-modules/03-terraform-aws-sg"
    project_name = var.project_name
    env_name = var.env_name
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    sg_name = "catalogue"
    sg_description = "SG for catalogue"
    #sg_ingress_rules = var.mongodb_sg_ingress_rules
}

module "user" {
    # source = "git::https://github.com/devopswitharunkumar/All-tools-revision-practice.git//7-terraform-modules/03-terraform-aws-sg?ref=main"
    source = "../../7-terraform-modules/03-terraform-aws-sg"
    project_name = var.project_name
    env_name = var.env_name
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    sg_name = "user"
    sg_description = "SG for user"
    #sg_ingress_rules = var.mongodb_sg_ingress_rules
}

module "cart" {
    # source = "git::https://github.com/devopswitharunkumar/All-tools-revision-practice.git//7-terraform-modules/03-terraform-aws-sg?ref=main"
    source = "../../7-terraform-modules/03-terraform-aws-sg"
    project_name = var.project_name
    env_name = var.env_name
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    sg_name = "cart"
    sg_description = "SG for cart"
    #sg_ingress_rules = var.mongodb_sg_ingress_rules
}

module "shipping" {
    # source = "git::https://github.com/devopswitharunkumar/All-tools-revision-practice.git//7-terraform-modules/03-terraform-aws-sg?ref=main"
    source = "../../7-terraform-modules/03-terraform-aws-sg"
    project_name = var.project_name
    env_name = var.env_name
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    sg_name = "shipping"
    sg_description = "SG for shipping"
    #sg_ingress_rules = var.mongodb_sg_ingress_rules
}

module "payment" {
    # source = "git::https://github.com/devopswitharunkumar/All-tools-revision-practice.git//7-terraform-modules/03-terraform-aws-sg?ref=main"
    source = "../../7-terraform-modules/03-terraform-aws-sg"
    project_name = var.project_name
    env_name = var.env_name
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    sg_name = "payment"
    sg_description = "SG for payment"
    #sg_ingress_rules = var.mongodb_sg_ingress_rules
}

module "web" {
    # source = "git::https://github.com/devopswitharunkumar/All-tools-revision-practice.git//7-terraform-modules/03-terraform-aws-sg?ref=main"
    source = "../../7-terraform-modules/03-terraform-aws-sg"
    project_name = var.project_name
    env_name = var.env_name
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    sg_name = "web"
    sg_description = "SG for web"
    #sg_ingress_rules = var.mongodb_sg_ingress_rules
}

module "dispatch" {
    # source = "git::https://github.com/devopswitharunkumar/All-tools-revision-practice.git//7-terraform-modules/03-terraform-aws-sg?ref=main"
    source = "../../7-terraform-modules/03-terraform-aws-sg"
    project_name = var.project_name
    env_name = var.env_name
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    sg_name = "dispatch"
    sg_description = "SG for dispatch"
    #sg_ingress_rules = var.mongodb_sg_ingress_rules
}

################# From Here Rules will start ##############################


#VPN 
resource "aws_security_group_rule" "openvpn_rule_to_connect_to_private_ec2_s" {
    security_group_id = module.vpn.sg_id
    type = "ingress"
    from_port = 0           #0 -- all ports
    to_port = 65535
    protocol = "-1"
    cidr_blocks = [ "0.0.0.0/0"]
}

#mongodb

#mongodb accepting connections from vpn 
resource "aws_security_group_rule" "mongodb_accept_vpn_traffic" {
    source_security_group_id = module.vpn.sg_id
    type = "ingress"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    security_group_id = module.mongodb.sg_id 
}

#mongodb accepting connections from catalogue 
resource "aws_security_group_rule" "mongodb_accept_catalogue_traffic" {
    source_security_group_id = module.catalogue.sg_id
    type = "ingress"
    from_port = 27017
    to_port = 27017
    protocol = "tcp"
    security_group_id = module.mongodb.sg_id
}

#mongodb accepting connections from user 
resource "aws_security_group_rule" "mongodb_accept_user_traffic" {
    source_security_group_id = module.user.sg_id
    type = "ingress"
    from_port = 27017
    to_port = 27017
    protocol = "tcp"
    security_group_id = module.mongodb.sg_id 
}

#redis 

#redis accepting connections from vpn 
resource "aws_security_group_rule" "redis_accept_vpn_traffic" {
    source_security_group_id = module.vpn.sg_id
    type = "ingress"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    security_group_id = module.redis.sg_id 
}

#redis accepting connections from user 
resource "aws_security_group_rule" "redis_accept_user_traffic" {
    source_security_group_id = module.user.sg_id
    type = "ingress"
    from_port = 6379
    to_port = 6379
    protocol = "tcp"
    security_group_id = module.redis.sg_id 
}

#redis accepting connections from catalogue 
resource "aws_security_group_rule" "redis_accept_cart_traffic" {
    source_security_group_id = module.cart.sg_id
    type = "ingress"
    from_port = 6379
    to_port = 6379
    protocol = "tcp"
    security_group_id = module.redis.sg_id
}

#mysql 
#mysql accepting connections from vpn 
resource "aws_security_group_rule" "mysql_accept_vpn_traffic" {
    source_security_group_id = module.vpn.sg_id
    type = "ingress"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    security_group_id = module.mysql.sg_id 
}

#mysql accepting connections from user 
resource "aws_security_group_rule" "mysql_accept_shipping_traffic" {
    source_security_group_id = module.shipping.sg_id
    type = "ingress"
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    security_group_id = module.mysql.sg_id 
}

#rabbitmq

#rabbitmq accepting connections from vpn 
resource "aws_security_group_rule" "rabbitmq_accept_vpn_traffic" {
  source_security_group_id = module.vpn.sg_id
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  security_group_id        = module.rabbitmq.sg_id 
}
#rabbitmq accepting connections from payment 
resource "aws_security_group_rule" "rabbitmq_accept_payment_traffic" {
    source_security_group_id = module.payment.sg_id 
  type              = "ingress"
  from_port         = 5672 
  to_port           = 5672 
  protocol          = "tcp"
  security_group_id = module.rabbitmq.sg_id 
}


#catalogue rules 
resource "aws_security_group_rule" "catalogue_accept_vpn_traffic" {
  source_security_group_id = module.vpn.sg_id
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  security_group_id        = module.catalogue.sg_id
}

resource "aws_security_group_rule" "catalogue_accept_web_traffic" {
  source_security_group_id = module.web.sg_id
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  security_group_id        = module.catalogue.sg_id
}

resource "aws_security_group_rule" "catalogue_accept_cart_traffic" {
  source_security_group_id = module.cart.sg_id
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  security_group_id        = module.catalogue.sg_id
}

#user rules 
resource "aws_security_group_rule" "user_accept_vpn_traffic" {
  source_security_group_id = module.vpn.sg_id
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  security_group_id        = module.user.sg_id
}

resource "aws_security_group_rule" "user_accept_web_traffic" {
  source_security_group_id = module.web.sg_id
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  security_group_id        = module.user.sg_id
}

resource "aws_security_group_rule" "user_accept_payment_traffic" {
  source_security_group_id = module.payment.sg_id
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  security_group_id        = module.user.sg_id
}

#cart rules 
resource "aws_security_group_rule" "cart_accept_vpn_traffic" {
  source_security_group_id = module.vpn.sg_id
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  security_group_id        = module.cart.sg_id
}

resource "aws_security_group_rule" "cart_accept_web_traffic" {
  source_security_group_id = module.web.sg_id
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  security_group_id        = module.cart.sg_id
}

resource "aws_security_group_rule" "cart_accept_shipping_traffic" {
  source_security_group_id = module.shipping.sg_id
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  security_group_id        = module.cart.sg_id
}

resource "aws_security_group_rule" "cart_accept_payment_traffic" {
  source_security_group_id = module.payment.sg_id
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  security_group_id        = module.cart.sg_id
}

#shipping rules 
resource "aws_security_group_rule" "shipping_accept_vpn_traffic" {
  source_security_group_id = module.vpn.sg_id
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  security_group_id        = module.shipping.sg_id
}

resource "aws_security_group_rule" "shipping_accept_web_traffic" {
  source_security_group_id = module.web.sg_id
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  security_group_id        = module.shipping.sg_id
}

#payment rules
resource "aws_security_group_rule" "payment_accept_vpn_traffic" {
  source_security_group_id = module.vpn.sg_id
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  security_group_id        = module.payment.sg_id
}

resource "aws_security_group_rule" "payment_accept_web_traffic" {
  source_security_group_id = module.web.sg_id
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  security_group_id        = module.payment.sg_id
}

#web rules
resource "aws_security_group_rule" "web_accept_vpn_tarrfic" {
  source_security_group_id = module.vpn.sg_id
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  security_group_id        = module.web.sg_id
}

resource "aws_security_group_rule" "web_accept_internet_traffic" {
  cidr_blocks = ["0.0.0.0/0"]
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  security_group_id        = module.web.sg_id
}




















































# #VPN Security Groups
# module "vpn" {
#   source = "../../7-terraform-modules/03-terraform-aws-sg"
#   project_name = var.project_name
#   env_name = var.env_name
#   #we need to take default vpc id remaining below sg groups should be created in roboshop vpc
#   vpc_id = data.aws_vpc.default_vpc_id.id
#   sg_name = "vpn"
#   sg_description = "sg for vpn"
#   #sg_ingress_rules = var.mongodb_sg_ingress_rules
# }



# #Database Security Groups
# module "mongodb" {
#   source = "../../7-terraform-modules/03-terraform-aws-sg"
#   project_name = var.project_name
#   env_name = var.env_name
#   vpc_id = data.aws_ssm_parameter.vpc_id.value 
#   sg_name = "mongodb"
#   sg_description = "sg for mongodb"
#   #sg_ingress_rules = var.mongodb_sg_ingress_rules
# }

# module "redis" {
#   source = "../../7-terraform-modules/03-terraform-aws-sg"
#   project_name = var.project_name
#   env_name = var.env_name
#   vpc_id = data.aws_ssm_parameter.vpc_id.value 
#   sg_name = "redis"
#   sg_description = "sg for redis"
#   #sg_ingress_rules = var.mongodb_sg_ingress_rules
# }

# module "mysql" {
#   source = "../../7-terraform-modules/03-terraform-aws-sg"
#   project_name = var.project_name
#   env_name = var.env_name
#   vpc_id = data.aws_ssm_parameter.vpc_id.value 
#   sg_name = "mysql"
#   sg_description = "sg for mysql"
#   #sg_ingress_rules = var.mongodb_sg_ingress_rules
# }

# module "rabbitmq" {
#   source = "../../7-terraform-modules/03-terraform-aws-sg"
#   project_name = var.project_name
#   env_name = var.env_name
#   vpc_id = data.aws_ssm_parameter.vpc_id.value 
#   sg_name = "rabbitmq"
#   sg_description = "sg for rabbitmq"
#   #sg_ingress_rules = var.mongodb_sg_ingress_rules
# }


# #Application Security Groups

# module "catalogue" {
#   source = "../../7-terraform-modules/03-terraform-aws-sg"
#   project_name = var.project_name
#   env_name = var.env_name
#   vpc_id = data.aws_ssm_parameter.vpc_id.value 
#   sg_name = "catalogue"
#   sg_description = "sg for catalogue"
#   #sg_ingress_rules = var.mongodb_sg_ingress_rules
# }

# module "cart" {
#   source = "../../7-terraform-modules/03-terraform-aws-sg"
#   project_name = var.project_name
#   env_name = var.env_name
#   vpc_id = data.aws_ssm_parameter.vpc_id.value 
#   sg_name = "cart"
#   sg_description = "sg for cart"
#   #sg_ingress_rules = var.mongodb_sg_ingress_rules
# }

# module "user" {
#   source = "../../7-terraform-modules/03-terraform-aws-sg"
#   project_name = var.project_name
#   env_name = var.env_name
#   vpc_id = data.aws_ssm_parameter.vpc_id.value 
#   sg_name = "user"
#   sg_description = "sg for user"
#   #sg_ingress_rules = var.mongodb_sg_ingress_rules
# }

# module "shipping" {
#   source = "../../7-terraform-modules/03-terraform-aws-sg"
#   project_name = var.project_name
#   env_name = var.env_name
#   vpc_id = data.aws_ssm_parameter.vpc_id.value 
#   sg_name = "shipping"
#   sg_description = "sg for shipping"
#   #sg_ingress_rules = var.mongodb_sg_ingress_rules
# }

# module "payment" {
#   source = "../../7-terraform-modules/03-terraform-aws-sg"
#   project_name = var.project_name
#   env_name = var.env_name
#   vpc_id = data.aws_ssm_parameter.vpc_id.value 
#   sg_name = "payment"
#   sg_description = "sg for payment"
#   #sg_ingress_rules = var.mongodb_sg_ingress_rules
# }

# module "web" {
#   source = "../../7-terraform-modules/03-terraform-aws-sg"
#   project_name = var.project_name
#   env_name = var.env_name
#   vpc_id = data.aws_ssm_parameter.vpc_id.value 
#   sg_name = "web"
#   sg_description = "sg for web"
#   #sg_ingress_rules = var.mongodb_sg_ingress_rules
# }


# ################# From Here Rules will start ##############################


# #for openvpn 
# resource "aws_security_group_rule" "openvpn_rule_to_connect_to_private_ec2_s" {
#   security_group_id = module.vpn.sg_id
#   type              = "ingress"
#   from_port         = 0
#   to_port           = 65535
#   protocol          = "-1"
#   cidr_blocks = ["0.0.0.0/0"]
# }

# # #extra i added
# # resource "aws_security_group_rule" "vpn_egress" {
# #   security_group_id = module.vpn.sg_id
# #   type        = "egress"
# #   from_port   = 0
# #   to_port     = 0
# #   protocol    = "-1"
# #   cidr_blocks = ["0.0.0.0/0"]
# #   description = "Allow VPN EC2 outbound internet access"
# # }

# #mongodb rules
# #mongodb accepting connections from catalogue instance instead of ingress rules because ip address is dynamic u can use this way
# resource "aws_security_group_rule" "mongodb_accept_catalogue_traffic" {
#     source_security_group_id = module.catalogue.sg_id
#   type              = "ingress"
#   from_port         = 27017
#   to_port           = 27017
#   protocol          = "tcp"
#   security_group_id = module.mongodb.sg_id
# }


# resource "aws_security_group_rule" "mongodb_accept_user_traffic" {
#     source_security_group_id = module.user.sg_id #from user to mongodb
#   type              = "ingress"
#   from_port         = 27017
#   to_port           = 27017
#   protocol          = "tcp"
#   security_group_id = module.mongodb.sg_id  #into mongodb in which sg we need to add other sg that sg id 
  
# }


# resource "aws_security_group_rule" "mongodb_accept_vpn_traffic" {
#     source_security_group_id = module.vpn.sg_id
#   type              = "ingress"
#   from_port         = 22
#   to_port           = 22
#   protocol          = "tcp"
#   security_group_id = module.mongodb.sg_id
# }



# #redis rules
# resource "aws_security_group_rule" "redis_accept_user_traffic" {
#     source_security_group_id = module.user.sg_id 
#   type              = "ingress"
#   from_port         = 6379
#   to_port           = 6379
#   protocol          = "tcp"
#   security_group_id = module.redis.sg_id 
# }


# resource "aws_security_group_rule" "redis_accept_cart_traffic" {
#     source_security_group_id = module.cart.sg_id 
#   type              = "ingress"
#   from_port         = 6379
#   to_port           = 6379
#   protocol          = "tcp"
#   security_group_id = module.redis.sg_id 
# }


# resource "aws_security_group_rule" "redis_accept_vpn_traffic" {
#     source_security_group_id = module.vpn.sg_id
#   type              = "ingress"
#   from_port         = 22
#   to_port           = 22
#   protocol          = "tcp"
#   security_group_id = module.redis.sg_id
# }

# #mysql rules
# resource "aws_security_group_rule" "mysql_accept_shipping_traffic" {
#     source_security_group_id = module.shipping.sg_id 
#   type              = "ingress"
#   from_port         = 3306 
#   to_port           = 3306 
#   protocol          = "tcp"
#   security_group_id = module.mysql.sg_id 
# }

# resource "aws_security_group_rule" "mysql_accept_vpn_traffic" {
#     source_security_group_id = module.vpn.sg_id
#   type              = "ingress"
#   from_port         = 22
#   to_port           = 22
#   protocol          = "tcp"
#   security_group_id = module.mysql.sg_id
# }



# #rabbitmq rules
# resource "aws_security_group_rule" "rabbitmq_accept_payment_traffic" {
#     source_security_group_id = module.payment.sg_id 
#   type              = "ingress"
#   from_port         = 5672 
#   to_port           = 5672 
#   protocol          = "tcp"
#   security_group_id = module.rabbitmq.sg_id 
# }

# resource "aws_security_group_rule" "rabbitmq_accept_vpn_traffic" {
#   source_security_group_id = module.vpn.sg_id
#   type                     = "ingress"
#   from_port                = 22
#   to_port                  = 22
#   protocol                 = "tcp"
#   security_group_id        = module.rabbitmq.sg_id 
# }



# #catalogue rules 
# resource "aws_security_group_rule" "catalogue_accept_vpn_traffic" {
#   source_security_group_id = module.vpn.sg_id
#   type                     = "ingress"
#   from_port                = 22
#   to_port                  = 22
#   protocol                 = "tcp"
#   security_group_id        = module.catalogue.sg_id
# }

# resource "aws_security_group_rule" "catalogue_accept_web_traffic" {
#   source_security_group_id = module.web.sg_id
#   type                     = "ingress"
#   from_port                = 8080
#   to_port                  = 8080
#   protocol                 = "tcp"
#   security_group_id        = module.catalogue.sg_id
# }

# resource "aws_security_group_rule" "catalogue_accept_cart_traffic" {
#   source_security_group_id = module.cart.sg_id
#   type                     = "ingress"
#   from_port                = 8080
#   to_port                  = 8080
#   protocol                 = "tcp"
#   security_group_id        = module.catalogue.sg_id
# }

# #user rules 
# resource "aws_security_group_rule" "user_accept_vpn_traffic" {
#   source_security_group_id = module.vpn.sg_id
#   type                     = "ingress"
#   from_port                = 22
#   to_port                  = 22
#   protocol                 = "tcp"
#   security_group_id        = module.user.sg_id
# }

# resource "aws_security_group_rule" "user_accept_web_traffic" {
#   source_security_group_id = module.web.sg_id
#   type                     = "ingress"
#   from_port                = 8080
#   to_port                  = 8080
#   protocol                 = "tcp"
#   security_group_id        = module.user.sg_id
# }

# resource "aws_security_group_rule" "user_accept_payment_traffic" {
#   source_security_group_id = module.payment.sg_id
#   type                     = "ingress"
#   from_port                = 8080
#   to_port                  = 8080
#   protocol                 = "tcp"
#   security_group_id        = module.user.sg_id
# }

# #cart rules 
# resource "aws_security_group_rule" "cart_accept_vpn_traffic" {
#   source_security_group_id = module.vpn.sg_id
#   type                     = "ingress"
#   from_port                = 22
#   to_port                  = 22
#   protocol                 = "tcp"
#   security_group_id        = module.cart.sg_id
# }

# resource "aws_security_group_rule" "cart_accept_web_traffic" {
#   source_security_group_id = module.web.sg_id
#   type                     = "ingress"
#   from_port                = 8080
#   to_port                  = 8080
#   protocol                 = "tcp"
#   security_group_id        = module.cart.sg_id
# }

# resource "aws_security_group_rule" "cart_accept_shipping_traffic" {
#   source_security_group_id = module.shipping.sg_id
#   type                     = "ingress"
#   from_port                = 8080
#   to_port                  = 8080
#   protocol                 = "tcp"
#   security_group_id        = module.cart.sg_id
# }

# resource "aws_security_group_rule" "cart_accept_payment_traffic" {
#   source_security_group_id = module.payment.sg_id
#   type                     = "ingress"
#   from_port                = 8080
#   to_port                  = 8080
#   protocol                 = "tcp"
#   security_group_id        = module.cart.sg_id
# }

# #shipping rules 
# resource "aws_security_group_rule" "shipping_accept_vpn_traffic" {
#   source_security_group_id = module.vpn.sg_id
#   type                     = "ingress"
#   from_port                = 22
#   to_port                  = 22
#   protocol                 = "tcp"
#   security_group_id        = module.shipping.sg_id
# }

# resource "aws_security_group_rule" "shipping_accept_web_traffic" {
#   source_security_group_id = module.web.sg_id
#   type                     = "ingress"
#   from_port                = 8080
#   to_port                  = 8080
#   protocol                 = "tcp"
#   security_group_id        = module.shipping.sg_id
# }

# #payment rules
# resource "aws_security_group_rule" "payment_accept_vpn_traffic" {
#   source_security_group_id = module.vpn.sg_id
#   type                     = "ingress"
#   from_port                = 22
#   to_port                  = 22
#   protocol                 = "tcp"
#   security_group_id        = module.payment.sg_id
# }

# resource "aws_security_group_rule" "payment_accept_web_traffic" {
#   source_security_group_id = module.web.sg_id
#   type                     = "ingress"
#   from_port                = 8080
#   to_port                  = 8080
#   protocol                 = "tcp"
#   security_group_id        = module.payment.sg_id
# }

# #web rules
# resource "aws_security_group_rule" "web_accept_vpn_tarrfic" {
#   source_security_group_id = module.vpn.sg_id
#   type                     = "ingress"
#   from_port                = 22
#   to_port                  = 22
#   protocol                 = "tcp"
#   security_group_id        = module.web.sg_id
# }

# resource "aws_security_group_rule" "web_accept_internet_traffic" {
#   cidr_blocks = ["0.0.0.0/0"]
#   type                     = "ingress"
#   from_port                = 80
#   to_port                  = 80
#   protocol                 = "tcp"
#   security_group_id        = module.web.sg_id
# }