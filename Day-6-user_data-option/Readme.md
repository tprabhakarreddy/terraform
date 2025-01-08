Topics discussed in today's class
-----------------------------------------
1. Lamda creation process in Terraform
2. Life Cycle rules in Terraform
3. -target Option in Terraform
4. depends_on Option in Terraform
5. User_data option in Terraform
----------------------------------------------------------------------------------

### user_data option
The `user_data` option in Terraform is a feature used with resources like `aws_instance` to pass custom configuration scripts to instances during their creation. These scripts typically run at instance startup and are commonly used to automate instance initialization tasks such as installing software, configuring applications, or setting up the environment.

-----------------------------------------------------------------------------
When automating tasks during instance initialization with `user_data`, you can pass scripts using either the inline approach (`<<EOF`) or the file reference approach (`file()` function). Below is a detailed comparison and examples for both methods.
#### Approach 1: Inline Script with <<EOF
**Use Case:**
Embed the script directly in the Terraform configuration file using a multi-line heredoc string.
```
# Create EC2 instance
resource "aws_instance" "ec2" {
  ami             = "ami-07d9cf938edb0739b"
  instance_type   = "t2.micro"
  key_name        = "newkey"
   # Inline user_data script
  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              echo "<h1>Welcome to My Website</h1>" > /var/www/html/index.html
              systemctl start httpd
              systemctl enable httpd
              EOF
}
```

#### Approach 2: Referencing an External Script File Using file()
**Use Case:**
Store the script in a separate file and reference it using the `file()` function.
```
# Create EC2 instance
resource "aws_instance" "ec2" {
  ami             = "ami-07d9cf938edb0739b"
  instance_type   = "t2.micro"
  key_name        = "newkey"
  
  # Inline user_data script
  user_data = file("user_data.sh")
```
**External Script File (user_data.sh):**
```
#!/bin/bash
yum update -y
yum install -y httpd
echo "<h1>Welcome to My Website(file)</h1>" > /var/www/html/index.html
systemctl start httpd
systemctl enable httpd
```

--------------------------------------------------------------------------------------------