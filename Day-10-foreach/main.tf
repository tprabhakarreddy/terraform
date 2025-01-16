provider "aws" {
  
}

variable "environment" {
  type = list(string)
  default = [ "dev","test","prod" ]

  /*Using for_each instead of count can help avoid disruptive recreation of resources when elements are added or removed from a list. 
  This is because for_each uses a map or set of values, and resources are uniquely identified by their keys, not by numeric indices.*/

  #default = [ "dev","prod" ]
}

resource "aws_s3_bucket" "name" {
    for_each = toset(var.environment)
    bucket = "prt-test-s3-${each.value}"
}