Topics discussed in today's class
-----------------------------------------
1. Build a Custom Network and Launch an EC2 Instance in Terraform
2. Import Existing Infrastructure into Terraform
----------------------------------------------------------------------------------

## Steps to Build a Custom Network and Launch an EC2 Instance in Terraform
Here are the steps to create a custom network with NAT and set up one public EC2 and one private EC2 instance

### 1. Create a Custom VPC
```
resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "myvpc"
  }
}
```
### 2. Create Two Subnets
**Public Subnet**
```
resource "aws_subnet" "subnet-1" {
  vpc_id            = aws_vpc.vpc.id
  availability_zone = "us-west-2a"
  cidr_block        = "10.0.1.0/24"
  tags = {
    Name = "mysubnet-1"
  }

}
```
**Private Subnet**
```
resource "aws_subnet" "subnet-2" {
  vpc_id            = aws_vpc.vpc.id
  availability_zone = "us-west-2a"
  cidr_block        = "10.0.2.0/24"
  tags = {
    Name = "mysubnet-2"
  }
}
```
### 3. Create an Internet Gateway
```
resource "aws_internet_gateway" "ig" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "myIG"
  }
    }
```
### 4. Allocate an Elastic IP for the NAT Gateway
```
resource "aws_eip" "nat_eip" {
  tags = {
    Name = "NatEIP"
  }
}
```

### 5. Create a NAT Gateway
```
# NAT Gateway
resource "aws_nat_gateway" "Nat_gate" {
  subnet_id     = aws_subnet.subnet-1.id
  allocation_id = aws_eip.nat_eip.id
}
```
### 6. Configure Route Tables
**Public Route Table**
```
resource "aws_route_table" "public_RT" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ig.id

  }
  tags = {
    Name = "pulic_RT"
  }
}
```
**Private Route Table**
```
resource "aws_route_table" "private_RT" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.Nat_gate.id
  }
  tags = {
    Name = "private_RT"
  }
}
```
### 7. Associate Subnets to Route Tables
**Public Subnet Association**
```
resource "aws_route_table_association" "public-RT-ass" {
  route_table_id = aws_route_table.public_RT.id
  subnet_id      = aws_subnet.subnet-1.id
}
```
**Private Subnet Association**
```
resource "aws_route_table_association" "Privat-RT-ass" {
  route_table_id = aws_route_table.private_RT.id
  subnet_id      = aws_subnet.subnet-2.id

}
```
### 8. Create Security Groups
```
resource "aws_security_group" "sg" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "mySG"
  }
  # Allow all Inbound traffic
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

    # For SSH
    # from_port = 22
    # to_port = 22
    # protocol   = "TCP"


  }
  # Allow all Oubound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}
```
### 9. Launch EC2 Instances
**Public EC2 Instance**
```
resource "aws_instance" "public" {
  ami                         = "ami-07d9cf938edb0739b"
  instance_type               = "t2.micro"
  key_name                    = "newkey"
  availability_zone           = "us-west-2a"
  subnet_id                   = aws_subnet.subnet-1.id
  security_groups             = [aws_security_group.sg.id]
  associate_public_ip_address = true
  tags = {
    Name = "PublicEC2"
  }

}

```

**Private EC2 Instance**
```
resource "aws_instance" "private" {
  ami                         = "ami-07d9cf938edb0739b"
  instance_type               = "t2.micro"
  key_name                    = "newkey"
  availability_zone           = "us-west-2a"
  subnet_id                   = aws_subnet.subnet-2.id
  security_groups             = [aws_security_group.sg.id]
  associate_public_ip_address = false
  tags = {
    Name = "PrivateEC2"
  }

}
```

### 10. Run Terraform commands
Run the Terraform commands
```
terraform init
terraform plan
terraform apply
```

### 11.Test Connectivity
SSH into the Public EC2 using its public IP.

From the Public EC2, SSH into the Private EC2 using its private IP

----------------------------------------------------------------------------------------------
