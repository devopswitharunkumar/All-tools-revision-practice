module "shipping" {
    source = "git::https://github.com/devopswitharunkumar/All-tools-revision-practice.git//9-roboshop-terraform-infra-dev/terraform-roboshop-app?ref=main"
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    tags = var.tags
    component_sg_id = data.aws_ssm_parameter.shipping_sg_id.value
    private_subnet_id = split(",", data.aws_ssm_parameter.private_subnet_id.value)
    iam_instance_profile = var.iam_instance_profile

    project_name = var.project_name
    env_name = var.env_name
    domain_name = var.domain_name
    common_tags = var.common_tags
    ami_id = data.aws_ami.redhat-9-ami-id.id
    app_alb_listner_rule = data.aws_ssm_parameter.app_alb_listner_rule.value
    rule_priority = var.rule_priority
    app_version = var.app_version
    packaging = var.packaging
    host_header_pattern = var.host_header_pattern
}