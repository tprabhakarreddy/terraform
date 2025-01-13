### Topics covered in today's class
1. Creating a Key Pair Using Terraform
2. Connection Block in Terraform
3. Provisioner usage in Terraform

-------------------------------------------------------------------
### Creating a Key Pair Using Terraform
In Terraform, you can create an SSH key pair to securely access resources like EC2 instances. Terraform uses the `aws_key_pair` resource to generate or import a key pair in AWS.

**Example:**  
Create a Key Pair from an Existing Public Key
If you already have an SSH key pair, you can use the public key to create an AWS key pair.

```
resource "aws_key_pair" "my_key_pair" {
    key_name   = "test_key1"
    public_key = file("~/.ssh/id_ed25519.pub") # Path to your existing public key
}
```
Attach the key pair to an EC2 instance for secure access.

```
resource "aws_instance" "my_instance" {
  ami           = "ami-07d9cf938edb0739b"
  instance_type = "t2.micro"
  key_name      = aws_key_pair.my_key_pair.id
 # key_name      = aws_key_pair.my_key_pair.key_name

}
```

---------------------------------------------------------------------------------
### Connection Block in Terraform
The `connection` block in Terraform is used to specify how Terraform communicates with a remote resource, such as an EC2 instance. It is typically used with `provisioner` blocks (e.g., `remote-exec`) to execute commands on the resource after it is created or modified.  

#### Key Attributes of the Connection Block  
- **Type:** Defines the connection method (e.g., ssh).  
- **User:** Specifies the username for the connection (e.g., ec2-user or ubuntu).  
- **Host:** Sets the hostname or IP address of the resource (e.g., self.public_ip).  
- **private_key Authentication:** Path to the SSH private key file.  

**Example:**
```
# Create new key pair
resource "aws_key_pair" "my_key_pair" {
    key_name   = "test_key1"
    public_key = file("~/.ssh/id_ed25519.pub") # Path to your existing public key
}

# Create New instance
resource "aws_instance" "my_instance" {
  ami           = "ami-07d9cf938edb0739b"
  instance_type = "t2.micro"
  key_name      = aws_key_pair.my_key_pair.key_name

 # Connect to EC2 instance
  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("~/.ssh/id_ed25519")
    host        = self.public_ip
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
}
```
--------------------------------------------------------------------------------------

### Terraform Provisioners and Usage
Provisioners in Terraform are used to execute scripts or commands on a resource once it is created or destroyed. They act as a way to bootstrap or configure resources that Terraform has created.  

#### Types of Provisioners

1. `file` **Provisioner:** Used to upload files or directories to a resource.
2. `local-exec` **Provisioner:** Executes commands locally (on the machine running Terraform).
3. `remote-exec` **Provisioner:** Executes commands remotely (on the target resource).

#### When to Use Provisioners
- Bootstrapping a VM with initial configurations.
- Installing software or dependencies after resource creation.
- Running custom scripts for specific use cases.  

**Example**
```
# Create new key pair
resource "aws_key_pair" "my_key_pair" {
    key_name   = "test_key1"
    public_key = file("~/.ssh/id_ed25519.pub") # Path to your existing public key
}

# Create New instance
resource "aws_instance" "my_instance" {
  ami           = "ami-07d9cf938edb0739b"
  instance_type = "t2.micro"
  key_name      = aws_key_pair.my_key_pair.key_name

 # Connect to EC2 instance
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
```

-------------------------------------------------------------------------------------