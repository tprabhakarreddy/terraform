# Retrieve the Default VPC ID
data "aws_vpc" "default"{
    default = true
}

# Create the Security Group
resource "aws_security_group" "example" {
  name        = "my-sg"
  vpc_id      = data.aws_vpc.default.id

  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }
}
