# Create new key pair
resource "aws_key_pair" "my_key_pair" {
  key_name   = "test_key1"
  public_key = file("~/.ssh/id_ed25519.pub")

}

# Create EC2 instance using new key pair
resource "aws_instance" "my_instance" {
  ami           = "ami-07d9cf938edb0739b"
  instance_type = "t2.micro"
  key_name      = aws_key_pair.my_key_pair.id
 # key_name      = aws_key_pair.my_key_pair.key_name

}
