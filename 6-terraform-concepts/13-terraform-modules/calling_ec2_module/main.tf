module "instance" {
    source = "../ec2-module"

    instance_type = var.instance_type
    tags = var.tags
}