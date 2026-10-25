module "vpn" {
    source = "terraform-aws-modules/ec2-instance/aws"

    name = "${local.ec2_name}-vpn"

    ami = data.aws_ami.redhat-9-ami-id.id
    instance_type = var.instance_type
    vpc_security_group_ids = [ data.aws_ssm_parameter.vpn_sg_id.value ]
    subnet_id = data.aws_subnet.default_st_from_default_vpc.id

    create_security_group = false #to not create default sg egress

    user_data = file("open_vpn.sh")


    tags = merge(var.common_tags, 
    {
        Component = "vpn"
    }, 
    {
        Name = "${local.ec2_name}-vpn"
    })

  
}