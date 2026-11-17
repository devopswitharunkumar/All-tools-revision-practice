###precedence 
We are give instance_type in diff places and diff values to test precedence 

we gave value in precedence.tfvars               -- t2.micro
we gave value in precedence.auto.tfvars          -- t2.small
we gave value in terraform.tfvars               -- t3.nano
we gave default value in variables.tf           -- t3.small

1  cmd line variable        --> terraform plan -var="instance_type=t2.nano"      
2  cmd line variable file   --> terraform plan -var-file=precedence.tfvars
3  auto.tfvars file         --> terraform plan 
4  terraform.tfvars file    --> terraform plan 
5  env                      --> export TF_VAR_instance_type="t3.micro"
6  value from variables.tf  --> terraform plan 
7  dont mention value anywhere it will prompt for value in terminal --> 