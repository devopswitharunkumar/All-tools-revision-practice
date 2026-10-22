resource "aws_instance" "func" {
    count = length(var.instance_names)          #1st collections function

    ami = var.ami
    instance_type = var.instance_names[count.index] == "mongodb" || var.instance_names[count.index] == "mysql" || var.instance_names[count.index] == "shipping" ? "t3.small" : "t2.micro"
    tags = {
        #String Functions
        name = upper("${var.proj_name}-${var.env_name}-${var.instance_names[count.index]}")      #"web-${count.index}"  -- for identical namesn b
        env = lower(join("-", [var.proj_name,var.env_name])) 
        split_func = join("-", split(",", "roboshop,dev,infra"))
        replace_env = replace("${var.proj_name}-${var.env_name}", var.env_name, "prod")

        #Numbe Functions
        calc_max_func = max(20,100,12)
        calc_min_func = min(20,100,12)

        #collections functions
        element_func = element([var.proj_name,var.env_name],0)
        contains_func = contains([var.proj_name,var.env_name],var.env_name)

        #map functions 
        keys_func = join(",", keys(var.servers))
        values_func = join(",",values(var.servers))
        lookup_func = lookup(var.servers, "mongodb")
        lookup_func_with_default = lookup(var.servers, "shipping","t2.micro")
    }  
}

resource "aws_route53_record" "route_dns" {
    count = 11
  zone_id = var.Zone_id
  name    = lower("${var.instance_names[count.index]}.${var.Domain_name}")
  type    = "A"
  ttl     = 1
  records = [var.instance_names[count.index] == "web" ? aws_instance.func[count.index].public_ip : aws_instance.func[count.index].private_ip]
}
