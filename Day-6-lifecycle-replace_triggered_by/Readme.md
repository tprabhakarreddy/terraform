Topics discussed in today's class
-----------------------------------------
1. Lamda creation process in Terraform
2. Life Cycle rules in Terraform
3. -target Option in Terraform
4. depends_on Option in Terraform
5. User_data option in Terraform
----------------------------------------------------------------------------------

### Life Cycle rules in Terraform
In Terraform, **lifecycle rules** are a feature used to manage how Terraform handles resource creation, update, and destruction during its operations. These rules are defined in a `lifecycle` block within a resource and provide control over the behavior of resources.  

#### Common Lifecycle Rules
1. `create_before_destroy`
Suppose you need to update an **AWS EC2 instance** that is running in a production environment. To avoid downtime, you want to ensure that Terraform creates a new EC2 instance before destroying the old one, so that the new instance can be provisioned and ready before the old one is terminated.

```
resource "aws_instance" "ec2" {
  ami             = "ami-07d9cf938edb0739b"
  instance_type   = "t2.micro"
  key_name        = "newkey"
  lifecycle {
    create_before_destroy = true
  }
}
```
- The old instance is not destroyed until the new one is successfully created, ensuring that the application or service running on the EC2 instance doesn’t experience downtime during updates.

--------------------------------------------------------------------------------------------
2. `prevent_destroy`
You have a **critical S3 bucket** used for storing important production data (e.g., logs, backups, or user-generated content). To ensure that this bucket cannot be accidentally deleted, you apply the `prevent_destroy` lifecycle rule to protect the bucket from being removed by Terraform, even if someone mistakenly runs `terraform destroy`.

```
resource "aws_s3_bucket" "s3" {
  bucket = "example-bucket"

  lifecycle {
    prevent_destroy = true
  }
}
```
- If you try to destroy this bucket, Terraform will raise an error.

---------------------------------------------------------------------------------

3. `ignore_changes`

You have an **EC2 instance** that is provisioned and managed by Terraform, but the **tags** of this instance are managed by another system (e.g., an automated service or a team that updates tags for resource tracking purposes). You don't want Terraform to overwrite or modify these tags during subsequent `terraform apply` runs, so you use the `ignore_changes` lifecycle rule to ignore changes to the `tags` attribute.

```
resource "aws_instance" "ec2" {
  ami             = "ami-07d9cf938edb0739b"
  instance_type   = "t2.micro"
  key_name        = "newkey"
  tags = {
    Name = "EC2"
  }

  lifecycle {
      ignore_changes = [ 
      tags
      ]
  }
}
```
- Ensures that tags updated by external processes or teams are not overwritten by Terraform. This is useful when multiple teams or systems are involved in managing different aspects of resources.

---------------------------------------------------------------------------------------------
4. `replace_triggered_by`
You have an **EC2 instance** that is associated with a **Security Group (SG)**. The **Security Group** configuration may change, and you want to ensure that Terraform replaces the EC2 instance if the Security Group is modified, even if other aspects of the EC2 instance (such as instance type or AMI) remain unchanged. You use the `replace_triggered_by` rule to trigger the replacement of the EC2 instance when the associated Security Group changes.

```
# Security Group
resource "aws_security_group" "web_sg" {
  name        = "web-sg"
  description = "Security group for web server"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 Instance
resource "aws_instance" "web_server" {
  ami             = "ami-07d9cf938edb0739b"
  instance_type   = "t2.micro"
  key_name        = "newkey"
  security_groups = [aws_security_group.web_sg.name]

  lifecycle {
    replace_triggered_by = [
      aws_security_group.web_sg.id
    ]
  }
}
```
- Ensures that when a critical resource like a Security Group is updated, related resources (like EC2 instances) are replaced to maintain a consistent security posture.

-------------------------------------------------------------------------------
