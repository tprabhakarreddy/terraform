output "instance_public_ip" {
  value       = aws_instance.dev.public_ip
  description = "The public IP address of the created EC2 instance"
}

