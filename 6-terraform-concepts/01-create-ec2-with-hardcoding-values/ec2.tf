resource "aws_instance" "vm_creation" {
    ami = "ami-0220d79f3f480ecf5"
    instance_type = "t2.micro"

    vpc_security_group_ids = [ aws_security_group.sg_without_vars.id ]

    tags = {
        name = "ec2_creation"
    }
}