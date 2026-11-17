resource "aws_instance" "conditions" {
    ami = data.aws_ami.ami_id_fetch.id
    instance_type = var.env == "dev" ? "t2.micro" : "t2.small"

    tags = var.tags_details
}