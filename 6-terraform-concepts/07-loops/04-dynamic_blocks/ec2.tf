resource "aws_instance" "count_instance" {
    count = 11
    ami =  var.ami
    instance_type = var.instance_names[count.index] == "mongodb" || var.instance_names[count.index] == "mysql" || var.instance_names[count.index] == "shipping" ? "t3.small" : "t2.micro"
    vpc_security_group_ids = [ aws_security_group.without_vars.id ]
    tags = {
        name = var.instance_names[count.index]      #"web-${count.index}"  -- for identical namesn b
    }  
}

resource "aws_route53_record" "route_dns" {
    count = 11
  zone_id = var.Zone_id
  name    = "${var.instance_names[count.index]}.${var.Domain_name}"
  type    = "A"
  ttl     = 1
  records = [var.instance_names[count.index] == "web" ? aws_instance.count_instance[count.index].public_ip : aws_instance.count_instance[count.index].private_ip]
}


resource "aws_security_group" "without_vars" {
    
  name = "security-hardcodening-values"
  description = "This is SG created with hardcodening values" 

  dynamic "ingress" {
    for_each = var.dynamic_blocks
    content {
        description = ingress.value["description"]
        from_port = ingress.value["from_port"]
        to_port = ingress.value["to_port"]
        protocol = ingress.value["protocol"]
        cidr_blocks = ingress.value["cidr_blocks"]
    }
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