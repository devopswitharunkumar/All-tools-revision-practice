resource "aws_instance" "count_instance" {
    count = 11
    ami =  var.ami
    instance_type = var.instance_names[count.index] == "mongodb" || var.instance_names[count.index] == "mysql" || var.instance_names[count.index] == "shipping" ? "t3.small" : "t2.micro"
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
