# Create VPC 
resource "aws_vpc" "myvpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "myvpc"
  }
}

# Create public Subnet-1
resource "aws_subnet" "subnet1-2a" {
  vpc_id            = aws_vpc.myvpc.id
  availability_zone = "us-west-2a"
  cidr_block        = "10.0.1.0/24"
  tags = {
    Name = "subnet1-2a"
  }
}

# Create Public Subnet-2
resource "aws_subnet" "subnet2-2b" {
  vpc_id            = aws_vpc.myvpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-west-2b"
  tags = {
    Name = "subnet2-2b"
  }

}


#Create Internet Gateway
resource "aws_internet_gateway" "myIG" {
  vpc_id = aws_vpc.myvpc.id
  tags = {
    Name = "myIG"
  }
}

# Create route table
resource "aws_route_table" "myRT" {
  vpc_id = aws_vpc.myvpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myIG.id
  }
  tags = {
    Name = "myRT"
  }
}


# Associates Subnet1 to route table
resource "aws_route_table_association" "ass-subnet1" {
  route_table_id = aws_route_table.myRT.id
  subnet_id      = aws_subnet.subnet1-2a.id
}

# Associates Subnet2 to route table
resource "aws_route_table_association" "ass-subnet2" {
  route_table_id = aws_route_table.myRT.id
  subnet_id      = aws_subnet.subnet2-2b.id
}

# Create Security Group
resource "aws_security_group" "mySG" {
  vpc_id = aws_vpc.myvpc.id
  tags = {
    Name = "mySG"
  }

  ingress = [
    for port in [80, 22, 3306] : {
      description      = "TLS from VPC"
      from_port        = port
      to_port          = port
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}
