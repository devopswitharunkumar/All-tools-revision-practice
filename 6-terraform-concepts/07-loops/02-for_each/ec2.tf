resource "aws_instance" "for_each_instance" {
    for_each = var.instance_names
    ami =  var.ami
    instance_type = each.value
    tags = {
        name = each.key      #"web-${count.index}"  -- for identical namesn b
    }  
}

resource "aws_route53_record" "route_dns" {
    for_each = var.instance_names
  zone_id = var.Zone_id
  name    = "${each.key}.${var.Domain_name}"
  type    = "A"
  ttl     = 1
  records = [ each.key == "web" ? aws_instance.for_each_instance[each.key].public_ip : aws_instance.for_each_instance[each.key].private_ip ]
}
