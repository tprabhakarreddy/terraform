# Create new key pair
resource "aws_key_pair" "keypair" {
  key_name   = "test_key1"
  public_key = file("~/.ssh/id_ed25519.pub")

}

# Create New instance
resource "aws_instance" "ec2" {
  ami           = "ami-07d9cf938edb0739b"
  instance_type = "t2.micro"
  key_name      = aws_key_pair.keypair.key_name

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("~/.ssh/id_ed25519")
    host        = self.public_ip
  }

  # Upload file to EC2 instance
  provisioner "file" {
    source      = "file.txt"
    destination = "/home/ec2-user/file.txt"
  }

  # Execute command on EC2 instance
  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo yum install httpd -y",
      "sudo systemctl start httpd",
      "sudo sh -c 'echo \"myserver - from provisioner\" > /var/www/html/index.html'"
    ]

  }

  #  Executes commands locally (on the machine running Terraform).
  provisioner "local-exec" {
    command = "echo ${self.public_ip} >> deployed_ips.txt"

  }

}


