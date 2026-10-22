resource "aws_instance" "module" {
  ami = data.aws_ami.ami_id_fetch.id 
  instance_type = var.instance_type
  vpc_security_group_ids = [ aws_security_group.module_sec.id ]

  tags = var.tags
}