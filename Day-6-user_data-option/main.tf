
# Create EC2 instance
resource "aws_instance" "ec2" {
  ami             = "ami-07d9cf938edb0739b"
  instance_type   = "t2.micro"
  key_name        = "newkey"
  
  # Inline user_data script
  # user_data = <<-EOF
  #             #!/bin/bash
  #             yum update -y
  #             yum install -y httpd
  #             echo "<h1>Welcome to My Website</h1>" > /var/www/html/index.html
  #             systemctl start httpd
  #             systemctl enable httpd
  #             EOF
# Using file approach
user_data=file("user_data.sh")
}


