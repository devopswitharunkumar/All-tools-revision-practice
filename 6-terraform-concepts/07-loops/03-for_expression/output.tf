output "instance_name" {
  value = [ for instance in var.instance_names : upper(instance)]
}