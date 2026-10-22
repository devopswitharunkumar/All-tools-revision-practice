resource "aws_instance" "ec2_dyn-vars" {
  ami = var.ami 
  instance_type = var.instance_type
  vpc_security_group_ids = [ aws_security_group.without_vars.id ]

  tags = var.tags_details
}