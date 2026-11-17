output "ec2_public_ip" {
  value = aws_instance.conditions.public_ip
}

output "ec2_private_ip" {
  value = aws_instance.conditions.private_ip
}

output "ec2_arn" {
  value = aws_instance.conditions.arn
}