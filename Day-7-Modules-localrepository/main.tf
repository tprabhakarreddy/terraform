module "name" {
  #source       = "github.com/tprabhakarreddy/terraform/Day-7-Modules-template"
  amiid        = "ami-07d9cf938edb0739b"
  instancetype = "t2.micro"
  keyname      = "newkey"
}
