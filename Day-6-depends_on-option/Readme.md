Topics discussed in today's class
-----------------------------------------
1. Lamda creation process in Terraform
2. Life Cycle rules in Terrafomr
3. -target Option in Terraform
4. depends_on Option in Terraform
5. User_data option in Terraform
----------------------------------------------------------------------------------

### depends_on option 
In Terraform, the `depends_on` option is used to explicitly define dependencies between resources, ensuring that certain resources are created, updated, or destroyed before others. While Terraform usually automatically manages resource dependencies based on references between resources, the `depends_on` option allows you to specify dependencies that are not directly related or referenced in resource attributes.

-----------------------------------------------------------------------------
#### Example Use Case
Suppose you may want to ensure that an aws_security_group is created before an EC2 instance.
```
# Create EC2 instance
resource "aws_instance" "ec2" {
  ami             = "ami-07d9cf938edb0739b"
  instance_type   = "t2.micro"
  key_name        = "newkey"
  security_groups = [aws_security_group.sg.name]

  depends_on = [
    aws_security_group.sg
  ]
}

# Create Security Group
resource "aws_security_group" "sg" {
  tags = {
    Name = "mySG"
  }
}

```
In this case, although `aws_instance.ec2` references `aws_security_group.sg`, the depends_on ensures that the security group is created first, even if Terraform can infer the correct order automatically

--------------------------------------------------------------------------------------------