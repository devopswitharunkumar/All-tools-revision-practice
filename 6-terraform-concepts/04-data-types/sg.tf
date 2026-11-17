resource "aws_security_group" "without_vars" {
  name = "security-hardcodening-values"
  description = "This is SG created with hardcodening values" 

  ingress {
    description = "Allow all for incoming traffic"
    from_port = var.from_port
    to_port = 0
    protocol = "-1"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  egress {
    description = "Allow all for outgoing traffic"
    from_port = var.from_port
    to_port = 0
    protocol = "-1"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
  tags = {
    name = "sg_without_variables"  
  }
}