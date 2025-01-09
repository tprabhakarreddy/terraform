# Create mysql database 
resource "aws_db_instance" "mysql_db" {
  identifier              = "prt-mysql-db"
  allocated_storage       = 20
  engine                  = "mysql"
  instance_class          = "db.t3.micro" # Free tier eligible instance class
  username                = "admin"
  password                = "mypassword123"
  publicly_accessible     = true
  skip_final_snapshot     = true
  db_subnet_group_name    = aws_db_subnet_group.db_subnet_group.id
  vpc_security_group_ids  = [aws_security_group.mySG.id]
  depends_on              = [aws_db_subnet_group.db_subnet_group]
  backup_retention_period = 7
}

# Create Subnet Group for Database 
resource "aws_db_subnet_group" "db_subnet_group" {
  subnet_ids = [aws_subnet.subnet1-2a.id, aws_subnet.subnet2-2b.id]
  tags = {
    Name = "db_subnet_group"
  }
}
