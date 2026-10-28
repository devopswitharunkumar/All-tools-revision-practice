#Creating target Group for APP-ALB
resource "aws_lb_target_group" "catalogue-app-alb-tg" {
  target_type = "instance"                      #it is default 
  name     = "${local.ec2_name}-${var.tags.Component}"
  protocol = "HTTP"
  port     = 8080
  vpc_id   = data.aws_ssm_parameter.vpc_id.value

  deregistration_delay = 60 

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
  priority     = 2

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
      instance_id = module.catalogue.id
    }

    provisioner "local-exec" {
        command = "aws ec2 terminate-instances --instance-ids ${module.catalogue.id}"
    
    }
    depends_on = [ aws_ami_from_instance.taking-ami-from-instance ]
}



#Launch template
resource "aws_launch_template" "catalogue-launch-tmplt" {
  name = "${local.ec2_name}-${var.tags.Component}-launch-tmplt"

  image_id = aws_ami_from_instance.taking-ami-from-instance.id
  
  instance_type = "t2.micro"
  
  instance_initiated_shutdown_behavior = "terminate"
  update_default_version = true 

  iam_instance_profile {
    name = "EC2RoleForShellScript"
  }

  vpc_security_group_ids = [data.aws_ssm_parameter.catalogue_sg_id.value]

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "${local.ec2_name}-${var.tags.Component}-launch-tmplt"
    }
  }
}

#Auto Scaling group creation for above launch template 
resource "aws_autoscaling_group" "catalogue-asg" {
  name                      = "${local.ec2_name}-${var.tags.Component}-Asg"
  max_size                  = 10
  min_size                  = 1
  desired_capacity          = 2
  health_check_grace_period = 100
  health_check_type         = "ELB"                     #load balancer will do health check
  
  vpc_zone_identifier       = split(",", data.aws_ssm_parameter.private_subnet_id.value)
  target_group_arns = [ aws_lb_target_group.catalogue-app-alb-tg.arn ]

   launch_template {
    id      = aws_launch_template.catalogue-launch-tmplt.id
    version = aws_launch_template.catalogue-launch-tmplt.latest_version
  }

  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 1
    }
    triggers = ["launch_template"]
  }

  tag {
    key                 = "Name"
    value               = "${local.ec2_name}-${var.tags.Component}-Asg"
    propagate_at_launch = true
  }

  timeouts {
    delete = "15m"
  }

}

#Auto scaling group policy for above ASG 
resource "aws_autoscaling_policy" "asg-policy" {
  autoscaling_group_name = aws_autoscaling_group.catalogue-asg.name

  name                   = "${local.ec2_name}-${var.tags.Component}-Asg-policy"
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 1.0
  }
  
}
