resource "aws_instance" "conditions" {
    ami = var.ami 
    instance_type = var.env == "dev" ? "t2.micro" : "t2.small"

    tags = var.tags_details
}