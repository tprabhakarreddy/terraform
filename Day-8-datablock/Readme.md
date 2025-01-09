### Topics covered in today's class
1. Data block
2. Create RDS using custom network
3. Create RDS using the module from terraform registry

-----------------------------------------------------------------------
### Data Block
In Terraform, a **data block** is used to retrieve or reference information from existing infrastructure or services in your cloud provider, rather than creating new resources. Data blocks are useful when you need to use existing resources as inputs for other resources in your Terraform configuration.  
**Syntax**  
Here’s the basic structure of a data block:
```
data "<PROVIDER>_<RESOURCE_TYPE>" "<NAME>" {
  # Configuration arguments
}
```
#### Example Use Cases  
Retrieve the most recent Amazon Linux 2 AMI:

```
#  Retrieve the existing ami id information.
data "aws_ami" "name" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-gp2"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

```

Create EC2 instance using above AMI ID
```
resource "aws_instance" "ec2" {
  ami           = data.aws_ami.name.id
  instance_type = "t2.micro"
  key_name      = "newkey" # Change to your key name
}
```
--------------------------------------------------------------------------------------


