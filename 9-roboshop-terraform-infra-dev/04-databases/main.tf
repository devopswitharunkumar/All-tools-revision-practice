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

resource "null_resource" "mongodb" {
    triggers = {
      instance_id = module.mongodb.id
    }

    connection {
      host = module.mongodb.private_ip
      type = "ssh"
      user = "ec2-user"
      password = "DevOps321"
    }

    provisioner "file" {
        source = "bootstrap.sh"
        destination = "/tmp/bootstarp.sh"  
    }

    provisioner "remote-exec" {
        inline = [ 
            "chmod +x /tmp/bootstrap.sh",
            "sudo sh /tmp/bootstrap.sh mongodb dev"
         ]
    }
  
}


module "redis" {
    source = "terraform-aws-modules/ec2-instance/aws"

    name = "${local.ec2_name}-redis"

    ami = data.aws_ami.redhat-9-ami-id.id
    instance_type = "t2.micro"
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
      host = module.redis.private_ip
      type = "ssh"
      user = "ec2-user"
      password = "DevOps321"
    }

    provisioner "file" {
        source = "bootstrap.sh"
        destination = "/tmp/bootstarp.sh"  
    }

    provisioner "remote-exec" {
        inline = [ 
            "chmod +x /tmp/bootstrap.sh",
            "sudo sh /tmp/bootstrap.sh redis dev"
         ]
    }
  
}




# #creating route53 records for above resources 
# resource "aws_route53_record" "roboshop_domain_names" {
#     for_each = local.dns_records
  
#   zone_id = data.aws_route53_zone.domain_zone_id.id
#   name = "${each.key}-${var.domain_name}"
#   type = "A"
#   ttl = 1

#   records = [each.value]
# }

# #creating Ansible server to do configuration in all servers
# module "ansible" {
#     source = "terraform-aws-modules/ec2-instance/aws"

#     name = "${local.ec2_name}-ansible"

#     ami = data.aws_ami.redhat-9-ami-id.id
#     instance_type = var.instance_type
#     vpc_security_group_ids = [ data.aws_ssm_parameter.vpn_sg_id.value ]
#     subnet_id = data.aws_vpc.default_vpc_id.id     #retreive like string

#     create_security_group = false

#     user_data = file("${path.module}/ec2-provision.sh")


#     tags = merge(var.common_tags, 
#     {
#         Component = "ansible"
#     }, 
#     {
#         Name = "${local.ec2_name}-ansible"
#     })
# }