output "private_ip" {
  value = module.instance.private_ip
}

output "public_ip" {
  value = module.instance.public_ip
}

output "availability_zone" {
  value = module.instance.availability_zone
}