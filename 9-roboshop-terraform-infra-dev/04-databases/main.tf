#database related Ec2 creation
module "mongodb" {
    source = "terraform-aws-modules/ec2-instance/aws"

    name = "${local.ec2_name}-mongodb"

    ami = data.aws_ami.redhat-9-ami-id.id
    instance_type = "t3.medium"
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

resource "null_resource" "mongodb" {
    triggers = {
      instance_id = module.mongodb.id
    }

    connection {
    host        = module.mongodb.private_ip
    type        = "ssh"
    user        = "ec2-user"
    password    = "DevOps321"
    timeout     = "3m"
    }

    provisioner "file" {
        source = "bootstrap.sh" 
        destination = "/home/ec2-user/bootstrap.sh"  
    }

    provisioner "remote-exec" {
        inline = [ 
            "chmod +x /home/ec2-user/bootstrap.sh",
            "sudo sh /home/ec2-user/bootstrap.sh mongodb dev"
         ]
    }
}

module "redis" {
    source = "terraform-aws-modules/ec2-instance/aws"

    name = "${local.ec2_name}-redis"

    ami = data.aws_ami.redhat-9-ami-id.id
    instance_type = "t2.small"
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

resource "null_resource" "redis" {
    triggers = {
      instance_id = module.redis.id
    }

    connection {
      host      = module.redis.private_ip
      type      = "ssh"
      user      = "ec2-user"
      password  = "DevOps321"
      timeout   = "3m"
    }

    provisioner "file" {
        source = "bootstrap.sh" 
        destination = "/home/ec2-user/bootstrap.sh"  
    }

    provisioner "remote-exec" {
        inline = [ 
            "chmod +x /home/ec2-user/bootstrap.sh",
            "sudo sh /home/ec2-user/bootstrap.sh redis dev"
         ]
    }
}

module "mysql" {
    source = "terraform-aws-modules/ec2-instance/aws"

    name = "${local.ec2_name}-mysql"

    ami = data.aws_ami.redhat-9-ami-id.id
    instance_type = "t3.medium"
    vpc_security_group_ids = [ data.aws_ssm_parameter.mysql_sg_id.value ]
    subnet_id = local.database_subnet_ids      #retreive like string

    iam_instance_profile = "EC2RoleForShellScript"
    create_security_group = false


    tags = merge(var.common_tags, 
    {
        Component = "mysql"
    }, 
    {
        Name = "${local.ec2_name}-mysql"
    })
}

resource "null_resource" "mysql" {
    triggers = {
      instance_id = module.mysql.id
    }

    connection {
      host      = module.mysql.private_ip
      type      = "ssh"
      user      = "ec2-user"
      password  = "DevOps321"
      timeout   = "3m"
    }

    provisioner "file" {
        source = "bootstrap.sh" 
        destination = "/home/ec2-user/bootstrap.sh"  
    }

    provisioner "remote-exec" {
        inline = [ 
            "chmod +x /home/ec2-user/bootstrap.sh",
            "sudo sh /home/ec2-user/bootstrap.sh mysql dev"
         ]
    }
}

module "rabbitmq" {
    source = "terraform-aws-modules/ec2-instance/aws"

    name = "${local.ec2_name}-rabbitmq"

    ami = data.aws_ami.redhat-9-ami-id.id
    instance_type = "t3.medium"
    vpc_security_group_ids = [ data.aws_ssm_parameter.rabbitmq_sg_id.value ]
    subnet_id = local.database_subnet_ids      #retreive like string

    iam_instance_profile = "EC2RoleForShellScript"
    create_security_group = false


    tags = merge(var.common_tags, 
    {
        Component = "rabbitmq"
    }, 
    {
        Name = "${local.ec2_name}-rabbitmq"
    })
}

resource "null_resource" "rabbitmq" {
    triggers = {
      instance_id = module.rabbitmq.id
    }

    connection {
      host      = module.rabbitmq.private_ip
      type      = "ssh"
      user      = "ec2-user"
      password  = "DevOps321"
      timeout   = "3m"
    }

    provisioner "file" {
        source = "bootstrap.sh" 
        destination = "/home/ec2-user/bootstrap.sh"  
    }

    provisioner "remote-exec" {
        inline = [ 
            "chmod +x /home/ec2-user/bootstrap.sh",
            "sudo sh /home/ec2-user/bootstrap.sh rabbitmq dev"
         ]
    }
}

#creating route53 records for above resources 
resource "aws_route53_record" "roboshop_domain_names" {
    for_each = local.dns_records
  
  zone_id = data.aws_route53_zone.domain_zone_id.id
  name = "${each.key}-${var.env_name}.${var.domain_name}"
  type = "A"
  ttl = 1

  records = [each.value]
}
