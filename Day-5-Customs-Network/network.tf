# Create VPC 
resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "myvpc"
  }
}

# Create Subnets public subnet

resource "aws_subnet" "subnet-1" {
  vpc_id            = aws_vpc.vpc.id
  availability_zone = "us-west-2a"
  cidr_block        = "10.0.1.0/24"
  tags = {
    Name = "mysubnet-1"
  }

}

# Create private subnet
resource "aws_subnet" "subnet-2" {
  vpc_id            = aws_vpc.vpc.id
  availability_zone = "us-west-2a"
  cidr_block        = "10.0.2.0/24"
  tags = {
    Name = "mysubnet-2"
  }

}

# Create Internet Gateway
resource "aws_internet_gateway" "ig" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "myIG"
  }
}

# Elastic IP for NAT
resource "aws_eip" "nat_eip" {
  tags = {
    Name = "NatEIP"
  }
}

# NAT Gateway
resource "aws_nat_gateway" "Nat_gate" {
  subnet_id     = aws_subnet.subnet-1.id
  allocation_id = aws_eip.nat_eip.id
}

# Create public route table
resource "aws_route_table" "public_RT" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ig.id

  }
  tags = {
    Name = "public_RT"
  }
}

# Create route table and map to NAT gateway
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


# Associate subnet to public route tables
resource "aws_route_table_association" "public-RT-ass" {
  route_table_id = aws_route_table.public_RT.id
  subnet_id      = aws_subnet.subnet-1.id
}

# Associate subnet to private route table
resource "aws_route_table_association" "Privat-RT-ass" {
  route_table_id = aws_route_table.private_RT.id
  subnet_id      = aws_subnet.subnet-2.id

}


# Create Security Group
resource "aws_security_group" "sg" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "mySG"
  }
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
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}



