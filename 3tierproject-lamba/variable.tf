variable "launch_templates" {
  default = {
    FrontEnd-template = {
      name          = "FrontEnd-template"
      instance_type = "t2.micro"
      key_name      = "mynewkey"
      description   = "FrontEnd-template"
    },
    BackEnd-template = {
      name          = "BackEnd-template"
      instance_type = "t2.micro"
      key_name      = "mynewkey"
      description   = "BackEnd-template"

    }
  }
}
