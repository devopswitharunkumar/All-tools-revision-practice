#Creating target Group for APP-ALB
resource "aws_lb_target_group" "catalogue-app-alb-tg" {
  target_type = "instance"                      #it is default 
  name     = "${local.ec2_name}-${var.tags.Component}"
  protocol = "HTTP"
  port     = 8080
  vpc_id   = data.aws_ssm_parameter.vpc_id.value

  health_check {
    path                = "/health"
    port                = 8080
    protocol            = "HTTP"
    healthy_threshold   = 2
    unhealthy_threshold = 3
    interval            = 10
    timeout             = 5
    matcher             = "200-299"
  }
}
#above Target Group is not attached to APP ALB bewlo we do that with listner rule 

#Creating listner rule for tagging Target Group with APP-ALB
resource "aws_lb_listener_rule" "catalogue_listner_rule" {
  listener_arn = data.aws_ssm_parameter.app_alb_listner_rule.value
  priority     = 10

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.catalogue-app-alb-tg.arn
  }

  condition {
    host_header {
      values = ["${var.tags.Component}.app-${var.env_name}.${var.domain_name}"]
    }
  }
}


#Creating Instance for taking AMI
module "catalogue" {
    source = "terraform-aws-modules/ec2-instance/aws"

    name = "${local.ec2_name}-${var.tags.Component}-ami"

    ami = data.aws_ami.redhat-9-ami-id.id
    instance_type = "t2.micro"
    vpc_security_group_ids = [ data.aws_ssm_parameter.catalogue_sg_id.value ]
    subnet_id = element(split(",", data.aws_ssm_parameter.private_subnet_id.value),0)

    iam_instance_profile = "EC2RoleForShellScript"
    create_security_group = false


    tags = merge(var.common_tags, var.tags,
    {
        Name = "${local.ec2_name}-catalogue-ami"
    })
}

#Provisioning catalogue Using Ansible in above instance 
resource "null_resource" "catalogue" {
    triggers = {
      instance_id = module.catalogue.id
    }

    connection {
      host      = module.catalogue.private_ip
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
            "sudo sh /home/ec2-user/bootstrap.sh catalogue dev"
         ]
    }
}

# #if u want to test above health check
# resource "aws_security_group_rule" "catalogue_accept_vpn_traffic" {
#   source_security_group_id = module.vpn.sg_id
#   type                     = "ingress"
#   from_port                = 8080
#   to_port                  = 8080
#   protocol                 = "tcp"
#   security_group_id        = module.catalogue.sg_id
# }


#Stopping Instance 
resource "aws_ec2_instance_state" "stop-instance" {
  instance_id = module.catalogue.id
  state       = "stopped"
  depends_on = [ null_resource.catalogue ]
}

#Taking AMI from Above instance 
resource "aws_ami_from_instance" "taking-ami-from-instance" {
  name               = "${local.ec2_name}-${var.tags.Component}-taking-ami-${local.current_timestamp}"
  source_instance_id = module.catalogue.id 
  depends_on = [ aws_ec2_instance_state.stop-instance ]
}

#Provisioning catalogue Using Ansible in above instance 
resource "null_resource" "terminate_instance" {
    triggers = {
      instance_id = aws_ami_from_instance.taking-ami-from-instance.id
    }

    provisioner "local-exec" {
        command = "aws ec2 terminate-instances --instance-ids ${module.catalogue.id}"
    
    }
    depends_on = [ aws_ami_from_instance.taking-ami-from-instance ]
}