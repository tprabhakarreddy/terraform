# Retrive subnet information of public-2a
data "aws_subnet" "subnet2a" {
  filter {
    name   = "tag:Name"
    values = ["public2a*"] # Change to your subnet name
  }
}

data "aws_subnet" "subnet2b" {
  filter {
    name   = "tag:Name"
    values = ["public2b*"] # Change to your subnet name
  }
}
