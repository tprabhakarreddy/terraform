output "instance_id" {
  value       = aws_instance.dev.id
  description = "The ID of the created EC2 instance"
}

output "instance_public_ip" {
  value       = aws_instance.dev.public_ip
  description = "The public IP address of the created EC2 instance"
}

