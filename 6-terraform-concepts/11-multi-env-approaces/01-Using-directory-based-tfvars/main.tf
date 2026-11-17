resource "aws_instance" "dir-based-ec2" {
    count = length(var.instance_type)
    ami = data.aws_ami.id_fetch.id
    instance_type = var.instance_type[count.index] == "mongodb" || var.instance_type[count.index] == "mysql" || var.instance_type[count.index] == "shipping" ? "t2.medium" : "t2.micro"
    tags = {
        Name = "${var.instance_type[count.index]}-${var.env_name}"
    }
}


resource "aws_route53_record" "dir-based_route53_record" {
    count = length(var.instance_type)

    zone_id = data.aws_route53_zone.my_zone_id.zone_id
    name    = "${var.instance_type[count.index]}-${var.env_name}.${var.Domain_name}"
    type    = "A"
    ttl     = 1
    records = [ var.instance_type[count.index] == "web" ? aws_instance.dir-based-ec2[count.index].public_ip : aws_instance.dir-based-ec2[count.index].private_ip ]

}

#or using functions we can do like below 
#     name    = "keys(var.instance_names).${var.Domain_name}"

#     records = [ startswith(keys(var.instance_names)[count.index], "web") ? aws_instance.dir-based-ec2[count.index].public_ip : aws_instance.dir-based-ec2[count.index].private_ip ]

