# run below command 
# terraform plan -var "instance_type=t4"
# It show the message 

variable "instance_type" {
  description = "The EC2 instance type"
  type        = string
  default     = "t2.micro"

  validation {
    condition     = contains(["t2.micro", "t2.medium", "t2.large"], var.instance_type)
    error_message = "The instance_type must be one of: t2.micro, t2.medium, t2.large"
  }
}