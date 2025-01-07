Topics discussed in today's class
-----------------------------------------
1. Lamda creation process in Terraform
2. Life Cycle rules in Terrafomr
3. -target Option in Terraform
4. depends_on Option in Terraform
5. User_data option in Terraform
----------------------------------------------------------------------------------

### `-target` option 
The `-target` option in Terraform is used to target a specific resource or set of resources during a Terraform operation (such as `apply`, `plan`, or `destroy`). It allows you to limit the scope of the operation to a specific resource, rather than applying changes to the entire infrastructure.

#### How to Use the -target Option
The -target option is followed by the resource address you want to target. The resource address is a string that represents the resource type and name, such as aws_instance.example or aws_lambda_function.my_lambda.

**Syntax**
```
terraform apply -target=<resource_address>
```
- **resource_address**: This is the identifier for the resource you want to target. It is typically in the format of `resource_type.resource_name`. For example, `aws_instance.example` or `aws_s3_bucket.my_bucket`.

------------------------------------------------------------------------------------------------
#### Example Use Case
Suppose you have a Terraform configuration with an EC2 instance and an S3 bucket, and you only want to apply changes to the EC2 instance while leaving the S3 bucket intact.

**Terraform Configuration** (`main.tf`)
```
resource "aws_instance" "ec2" {
  ami           = "ami-07d9cf938edb0739b"
  instance_type = "t2.micro"
  key_name      = "newkey"
}

resource "aws_s3_bucket" "my_bucket" {
  bucket = "my-unique-bucket-name"
}
```

To apply changes only to the aws_instance.ec2 resource, you would run:
```
terraform apply -target=aws_instance.ec2
```
This would apply changes to only the EC2 instance, leaving the S3 bucket untouched.

--------------------------------------------------------------------------------------------