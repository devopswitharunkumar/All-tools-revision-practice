output "private_ip" {
  value = aws_instance.module.private_ip
}

output "public_ip" {
  value = aws_instance.module.public_ip
}

output "availability_zone" {
  value = aws_instance.module.availability_zone
}

output "arn" {
  value = aws_instance.module.arn
}