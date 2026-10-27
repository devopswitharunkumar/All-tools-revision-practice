resource "aws_lb_target_group" "app-alb-tg" {
  target_type = "instance"                      #it is default 
  name     = "${local.ec2_name}-${var.tags.Component}"
  protocol = "HTTP"
  port     = 8080
  vpc_id   = data.aws_ssm_parameter.vpc_id.value

  health_check {
    path                = "/"
    port                = 8080
    protocol            = "HTTP"
    healthy_threshold   = 2
    unhealthy_threshold = 3
    interval            = 10
    timeout             = 5
    matcher             = "200-299"
  }
}











# module "catalogue" {
#     source = "terraform-aws-modules/ec2-instance/aws"

#     name = "${local.ec2_name}-catalogue-ami"

#     ami = data.aws_ami.redhat-9-ami-id.id
#     instance_type = "t2.micro"
#     vpc_security_group_ids = [ data.aws_ssm_parameter.catalogue_sg_id.value ]
#     subnet_id = element(split(",", data.aws_ssm_parameter.private_subnet_id.value),0)

#     iam_instance_profile = "EC2RoleForShellScript"
#     create_security_group = false


#     tags = merge(var.common_tags, var.tags,
#     {
#         Name = "${local.ec2_name}-catalogue-ami"
#     })
# }

# resource "null_resource" "catalogue" {
#     triggers = {
#       instance_id = module.catalogue.id
#     }

#     connection {
#       host      = module.catalogue.private_ip
#       type      = "ssh"
#       user      = "ec2-user"
#       password  = "DevOps321"
#       timeout   = "3m"
#     }

#     provisioner "file" {
#         source = "bootstrap.sh" 
#         destination = "/home/ec2-user/bootstrap.sh"  
#     }

#     provisioner "remote-exec" {
#         inline = [ 
#             "chmod +x /home/ec2-user/bootstrap.sh",
#             "sudo sh /home/ec2-user/bootstrap.sh catalogue dev"
#          ]
#     }
# }

# #if u want to test above health check
# resource "aws_security_group_rule" "catalogue_accept_vpn_traffic" {
#   source_security_group_id = module.vpn.sg_id
#   type                     = "ingress"
#   from_port                = 8080
#   to_port                  = 8080
#   protocol                 = "tcp"
#   security_group_id        = module.catalogue.sg_id
# }



# resource "aws_ec2_instance_state" "stop-instance" {
#   instance_id = module.catalogue.id
#   state       = "stopped"
#   depends_on = [ null_resource.catalogue ]
# }
