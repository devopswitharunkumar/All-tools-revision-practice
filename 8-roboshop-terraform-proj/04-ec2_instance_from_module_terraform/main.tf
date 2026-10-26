#database related Ec2 creation
module "mongodb" {
    source = "terraform-aws-modules/ec2-instance/aws"

    name = "${local.ec2_name}-mongodb"

    ami = data.aws_ami.redhat-9-ami-id.id
    instance_type = "t3.small"
    vpc_security_group_ids = [ data.aws_ssm_parameter.mongodb_sg_id.value ]
    subnet_id = local.database_subnet_ids      #retreive like string

    create_security_group = false

    tags = merge(var.common_tags, 
    {
        Component = "mongodb"
    }, 
    {
        Name = "${local.ec2_name}-mongodb"
    })
}

module "redis" {
    source = "terraform-aws-modules/ec2-instance/aws"

    name = "${local.ec2_name}-redis"

    ami = data.aws_ami.redhat-9-ami-id.id
    instance_type = var.instance_type
    vpc_security_group_ids = [ data.aws_ssm_parameter.redis_sg_id.value ]
    subnet_id = local.database_subnet_ids      #retreive like string

    create_security_group = false


    tags = merge(var.common_tags, 
    {
        Component = "redis"
    }, 
    {
        Name = "${local.ec2_name}-redis"
    })
}

module "mysql" {
    source = "terraform-aws-modules/ec2-instance/aws"

    name = "${local.ec2_name}-mysql"

    ami = data.aws_ami.redhat-9-ami-id.id
    instance_type = "t3.small"
    vpc_security_group_ids = [ data.aws_ssm_parameter.mysql_sg_id.value ]
    subnet_id = local.database_subnet_ids      #retreive like string

    create_security_group = false

    tags = merge(var.common_tags, 
    {
        Component = "mysql"
    }, 
    {
        Name = "${local.ec2_name}-mysql"
    })
}

module "rabbitmq" {
    source = "terraform-aws-modules/ec2-instance/aws"

    name = "${local.ec2_name}-rabbitmq"

    ami = data.aws_ami.redhat-9-ami-id.id
    instance_type = var.instance_type
    vpc_security_group_ids = [ data.aws_ssm_parameter.rabbitmq_sg_id.value ]
    subnet_id = local.database_subnet_ids      #retreive like string

    create_security_group = false

    tags = merge(var.common_tags, 
    {
        Component = "rabbitmq"
    }, 
    {
        Name = "${local.ec2_name}-rabbitmq"
    })
}

#backend app related Ec2 creation
module "catalogue" {
    source = "terraform-aws-modules/ec2-instance/aws"

    name = "${local.ec2_name}-catalogue"

    ami = data.aws_ami.redhat-9-ami-id.id
    instance_type = var.instance_type
    vpc_security_group_ids = [ data.aws_ssm_parameter.catalogue_sg_id.value ]
    subnet_id = local.private_subnet_ids      #retreive like string

    create_security_group = false

    tags = merge(var.common_tags, 
    {
        Component = "catalogue"
    }, 
    {
        Name = "${local.ec2_name}-catalogue"
    })
}

module "user" {
    source = "terraform-aws-modules/ec2-instance/aws"

    name = "${local.ec2_name}-user"

    ami = data.aws_ami.redhat-9-ami-id.id
    instance_type = var.instance_type
    vpc_security_group_ids = [ data.aws_ssm_parameter.user_sg_id.value ]
    subnet_id = local.private_subnet_ids      #retreive like string

    create_security_group = false

    tags = merge(var.common_tags, 
    {
        Component = "user"
    }, 
    {
        Name = "${local.ec2_name}-user"
    })
}

module "cart" {
    source = "terraform-aws-modules/ec2-instance/aws"

    name = "${local.ec2_name}-cart"

    ami = data.aws_ami.redhat-9-ami-id.id
    instance_type = var.instance_type
    vpc_security_group_ids = [ data.aws_ssm_parameter.cart_sg_id.value ]
    subnet_id = local.private_subnet_ids      #retreive like string

    create_security_group = false

    tags = merge(var.common_tags, 
    {
        Component = "cart"
    }, 
    {
        Name = "${local.ec2_name}-cart"
    })
}

module "shipping" {
    source = "terraform-aws-modules/ec2-instance/aws"

    name = "${local.ec2_name}-shipping"

    ami = data.aws_ami.redhat-9-ami-id.id
    instance_type = "t3.small"
    vpc_security_group_ids = [ data.aws_ssm_parameter.shipping_sg_id.value ]
    subnet_id = local.private_subnet_ids      #retreive like string

    create_security_group = false

    tags = merge(var.common_tags, 
    {
        Component = "shipping"
    }, 
    {
        Name = "${local.ec2_name}-shipping"
    })
}

module "payment" {
    source = "terraform-aws-modules/ec2-instance/aws"

    name = "${local.ec2_name}-payment"

    ami = data.aws_ami.redhat-9-ami-id.id
    instance_type = var.instance_type
    vpc_security_group_ids = [ data.aws_ssm_parameter.payment_sg_id.value ]
    subnet_id = local.private_subnet_ids      #retreive like string

    create_security_group = false

    tags = merge(var.common_tags, 
    {
        Component = "payment"
    }, 
    {
        Name = "${local.ec2_name}-payment"
    })
}

module "web" {
    source = "terraform-aws-modules/ec2-instance/aws"

    name = "${local.ec2_name}-web"

    ami = data.aws_ami.redhat-9-ami-id.id
    instance_type = var.instance_type
    vpc_security_group_ids = [ data.aws_ssm_parameter.web_sg_id.value ]
    subnet_id = local.private_subnet_ids   #retreive like string

    create_security_group = false
    # associate_public_ip_address = true

    tags = merge(var.common_tags, 
    {
        Component = "web"
    }, 
    {
        Name = "${local.ec2_name}-web"
    })
}


#creating route53 records for above resources 
resource "aws_route53_record" "roboshop_domain_names" {
    for_each = local.dns_records
  
  zone_id = data.aws_route53_zone.domain_zone_id.id
  name = "${each.key}.${var.domain_name}"
  type = "A"
  ttl = 1

  records = [each.value]
}

#creating Ansible server to do configuration in all servers
module "ansible" {
    source = "terraform-aws-modules/ec2-instance/aws"

    name = "${local.ec2_name}-ansible"

    ami = data.aws_ami.redhat-9-ami-id.id
    instance_type = var.instance_type
    vpc_security_group_ids = [ data.aws_ssm_parameter.vpn_sg_id.value ]
    subnet_id = data.aws_subnet.default_subnet_from_default_vpc.id     #retreive like string

    create_security_group = false

    user_data = file("ec2-provision-through-ansible.sh")


    tags = merge(var.common_tags, 
    {
        Component = "ansible"
    }, 
    {
        Name = "${local.ec2_name}-ansible"
    })
}