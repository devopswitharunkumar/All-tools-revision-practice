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



#when ur not able to connect to components run below command inside vpn instance after login
# sudo iptables -I OPENVPN_INSTALL_FORWARD 1 -s 10.8.0.0/24 -d 10.0.0.0/16 -j ACCEPT
# sudo iptables -S OPENVPN_INSTALL_FORWARD --> it should show Accept for 10.8.....