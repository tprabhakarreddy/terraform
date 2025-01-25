# Create template for FrontEnd server
resource "aws_launch_template" "FrontEnd-template" {
  name                   = var.launch_templates["FrontEnd-template"].name
  description            = var.launch_templates["FrontEnd-template"].description
  image_id               = data.aws_ami.FrontEnd-ami.id
  instance_type          = var.launch_templates["FrontEnd-template"].instance_type
  key_name               = var.launch_templates["FrontEnd-template"].key_name
  vpc_security_group_ids = [aws_security_group.mySG.id]
  user_data              = filebase64("frontend-lt.sh")
  update_default_version = true
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = var.launch_templates["FrontEnd-template"].name
    }
  }
}

resource "aws_launch_template" "BackEnd-template" {
  name                   = var.launch_templates["BackEnd-template"].name
  description            = var.launch_templates["BackEnd-template"].description
  image_id               = data.aws_ami.BackEnd-ami.id
  instance_type          = var.launch_templates["BackEnd-template"].instance_type
  key_name               = var.launch_templates["BackEnd-template"].key_name
  vpc_security_group_ids = [aws_security_group.mySG.id]
  user_data              = filebase64("backend-lt.sh")
  update_default_version = true
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = var.launch_templates["BackEnd-template"].name
    }
  }
}


# Create Auto Scaling Group for ForntEnd
resource "aws_autoscaling_group" "FrontEnd-ASG" {
  name             = "FrontEnd-asg"
  min_size         = 1
  max_size         = 1
  desired_capacity = 1
  vpc_zone_identifier = [
    aws_subnet.public-subnet["public1a"].id,
    aws_subnet.public-subnet["public2b"].id
  ]
  target_group_arns = [aws_lb_target_group.FrontEnd-tg.arn]
  launch_template {
    id      = aws_launch_template.FrontEnd-template.id
    version = aws_launch_template.FrontEnd-template.latest_version
  }
  health_check_type = "EC2"
  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
    }
    # Triggers
    triggers = [
      "desired_capacity"
    ]
  }
  tag {
    key                 = "Name"
    value               = "FrontEnd-asg"
    propagate_at_launch = true
  }

}


# Create Auto Scaling Group for BackEnd
resource "aws_autoscaling_group" "BackEnd-ASG" {
  name             = "BackEnd-asg"
  min_size         = 1
  max_size         = 1
  desired_capacity = 1
  vpc_zone_identifier = [
    aws_subnet.public-subnet["public1a"].id,
    aws_subnet.public-subnet["public2b"].id
  ]
  target_group_arns = [aws_lb_target_group.BackEnd-tg.arn]
  launch_template {
    id      = aws_launch_template.BackEnd-template.id
    version = aws_launch_template.BackEnd-template.latest_version
  }
  health_check_type = "EC2"
  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
    }
    # Triggers
    triggers = [
      "desired_capacity"
    ]
  }
  tag {
    key                 = "Name"
    value               = "BackEnd-asg"
    propagate_at_launch = true
  }
}