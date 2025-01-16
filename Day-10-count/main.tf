provider "aws" {
  
}

variable "environment" {
  type = list(string)
  default = [ "dev","test","prod" ]

  /*Adding or removing an element in the count list causes Terraform to destroy and recreate resources. 
  This behavior is disruptive, especially for resources that maintain state (e.g., databases).*/
  
  #default = [ "dev","prod" ]
}
resource "aws_s3_bucket" "name" {
    count = length(var.environment)
    bucket = "prt-test-s3-${var.environment[count.index]}"
}