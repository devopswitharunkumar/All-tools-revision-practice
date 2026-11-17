resource "aws_security_group" "module_sec" {
  name = "security-hardcodening-values"
  description = "This is SG created with hardcodening values" 

  ingress {
    description = var.ingress_description
    from_port = var.from_port
    to_port = var.to_port
    protocol = var.protocol
    cidr_blocks = var.cidr
  }

  egress {
    description = var.egress_description
    from_port = var.from_port
    to_port = var.to_port
    protocol = var.protocol
    cidr_blocks = var.cidr
  }
  tags = {
    name = "sg_without_variables"  
  }
}