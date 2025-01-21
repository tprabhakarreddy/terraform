resource "aws_key_pair" "keypair" {
  key_name   = "test_key1"
  public_key = file("~/.ssh/id_ed25519.pub")

}

# Ubuntu Bastion Host
resource "aws_instance" "bastion" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public-subnet["public1a"].id
  key_name      = aws_key_pair.keypair.key_name
  associate_public_ip_address = true
  security_groups = [aws_security_group.mySG.id]
  user_data = filebase64("bastion.sh")

  tags = {
    Name = "bastion-host"
  }

   connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("~/.ssh/id_ed25519")
      host        = self.public_ip
    }

     # Copy the SQL file to the bastion host
  provisioner "file" {
    source      = "test.sql"        # Local file path
    destination = "/tmp/test.sql"  # Remote file path
  }
    
provisioner "remote-exec" {
  inline = [
    "mysql -h ${aws_db_instance.mysql_db.endpoint} -u ${aws_db_instance.mysql_db.username} -p'${aws_db_instance.mysql_db.password}' < /tmp/test.sql"
  ]
}
}