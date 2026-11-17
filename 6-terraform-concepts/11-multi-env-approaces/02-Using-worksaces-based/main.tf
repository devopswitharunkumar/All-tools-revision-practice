resource "aws_instance" "dir-based-ec2" {
    for_each = local.instance_names[terraform.workspace]
    ami = data.aws_ami.id_fetch.id
    instance_type = each.value
    tags = {
        Name = "${each.key}-${terraform.workspace}"
    }
}


resource "aws_route53_record" "dir-based_route53_record" {
    for_each = local.instance_names[terraform.workspace]

    zone_id = data.aws_route53_zone.my_zone_id.zone_id
    name    = "${each.key}-${terraform.workspace}.${var.Domain_name}"
    type    = "A"
    ttl     = 1
    records = [ startswith(local.instance_names[terraform.workspace][each.key], "web") ? aws_instance.dir-based-ec2[each.key].public_ip : aws_instance.dir-based-ec2[each.key].private_ip ]

}

