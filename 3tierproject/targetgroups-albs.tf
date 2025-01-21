
# Create target group for FrontEnd server
resource "aws_lb_target_group" "FrontEnd-tg" {
  name       = "FrontEnd-alb-tg"
  port       = 80
  protocol   = "HTTP"
  vpc_id     = aws_vpc.myvpc.id
  depends_on = [aws_vpc.myvpc]
}

# Create Load Balacer for FrontEnd Server
resource "aws_lb" "FrontEnd-alb" {
  name               = "FrontEnd-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.mySG.id]
  subnets            = [for subnet in aws_subnet.public-subnet : subnet.id]
  tags = {
    Name = "FrontEnd-ALB"
  }
  depends_on = [aws_lb_target_group.FrontEnd-tg]
}

# Cerate Load balancer listner for 
resource "aws_lb_listener" "FrontEnd_lb_listener" {
  load_balancer_arn = aws_lb.FrontEnd-alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.FrontEnd-tg.arn
  }
  depends_on = [aws_lb.FrontEnd-alb]
}



# Create target group for BackEnd server
resource "aws_lb_target_group" "BackEnd-tg" {
  name       = "BackEnd-alb-tg"
  port       = 80
  protocol   = "HTTP"
  vpc_id     = aws_vpc.myvpc.id
  depends_on = [aws_vpc.myvpc]
}

# Create Load Balacer for BackEnd Server
resource "aws_lb" "BackEnd-alb" {
  name               = "BackEnd-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.mySG.id]
  subnets            = [for subnet in aws_subnet.public-subnet : subnet.id]
  tags = {
    Name = "BackEnd-ALB"
  }
  depends_on = [aws_lb_target_group.BackEnd-tg]
}

# Cerate Load balancer listner for 
resource "aws_lb_listener" "BackEndEnd_lb_listener" {
  load_balancer_arn = aws_lb.BackEnd-alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.BackEnd-tg.arn
  }
  depends_on = [aws_lb.BackEnd-alb]
}
