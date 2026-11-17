resource "aws_instance" "data-types-ec2" {
    ami = var.ami 
    instance_type = var.instance_type[0]
    vpc_security_group_ids = [ aws_security_group.without_vars.id ]
    tags = var.tags_details
}