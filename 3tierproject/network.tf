# Create VPC 
resource "aws_vpc" "myvpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "myvpc"
  }
}

# Create public Subnets
resource "aws_subnet" "public-subnet" {
  for_each = {
    public1a = "10.0.1.0/24"
    public2b = "10.0.2.0/24"
  }
  vpc_id            = aws_vpc.myvpc.id
  availability_zone = "us-west-2${substr(each.key, -1, 1)}"
  cidr_block        = each.value
  tags = {
    Name = "public-subnet-${each.key}"
  }
}

# Create private Subnets

resource "aws_subnet" "private-subnet" {
  for_each = {
    private1a = "10.0.3.0/24"
    private2b = "10.0.4.0/24"
  }
  vpc_id            = aws_vpc.myvpc.id
  availability_zone = "us-west-2${substr(each.key, -1, 1)}"
  cidr_block        = each.value
  tags = {
    Name = "private-subnet-${each.key}"
  }
}


#Create Internet Gateway
resource "aws_internet_gateway" "myIG" {
  vpc_id = aws_vpc.myvpc.id
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
  subnet_id     = aws_subnet.public-subnet["public1a"].id
  allocation_id = aws_eip.nat_eip.id
}


# Create route table
resource "aws_route_table" "public_RT" {
  vpc_id = aws_vpc.myvpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myIG.id
  }
  tags = {
    Name = "public_RT"
  }
}


# Create route table and map to NAT gateway
resource "aws_route_table" "private_RT" {
  vpc_id = aws_vpc.myvpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.Nat_gate.id
  }
  tags = {
    Name = "private_RT"
  }
}


# Associates public Subnets to public route table
resource "aws_route_table_association" "public-rt-subnet-ass" {
  for_each       = aws_subnet.public-subnet
  route_table_id = aws_route_table.public_RT.id
  subnet_id      = each.value.id
}

# Associates private subnets to private route table
resource "aws_route_table_association" "private-rt-subnet-ass" {
  for_each       = aws_subnet.private-subnet
  route_table_id = aws_route_table.private_RT.id
  subnet_id      = each.value.id
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
