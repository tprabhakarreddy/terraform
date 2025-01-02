resource "aws_instance" "dev" {
  # Missing required key_name argument
  instance_type = "t2.nano"
  key_name = var.key_name

}
