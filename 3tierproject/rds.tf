# Create mysql database 
resource "aws_db_instance" "mysql_db" {
  identifier              = "prt-mysql-db"
  allocated_storage       = 20
  engine                  = "mysql"
  instance_class          = "db.t3.micro" # Free tier eligible instance class
  username                = "admin"
  password                = "test123456"
  publicly_accessible     = false
  skip_final_snapshot     = true
  db_subnet_group_name    = aws_db_subnet_group.db_subnet_group.id
  vpc_security_group_ids  = [aws_security_group.mySG.id]
  depends_on              = [aws_db_subnet_group.db_subnet_group]
  backup_retention_period = 7
  multi_az               = true
}

# Create Subnet Group for Database 
resource "aws_db_subnet_group" "db_subnet_group" {
  subnet_ids = [
    aws_subnet.private-subnet["private1a"].id,
    aws_subnet.private-subnet["private2b"].id
  ]
  tags = {
    Name = "db_subnet_group"
  }
}


# Use local-exec provisioner to run SQL script on the RDS instance after creation
/*resource "null_resource" "run_sql_script" {
  depends_on = [aws_db_instance.mysql_db]

  provisioner "local-exec" {
    command = "mysql -h ${aws_route53_record.rds_route53_record.name} -u ${aws_db_instance.mysql_db.username} -p${aws_db_instance.mysql_db.password} < test.sql"
  }
}*/