Topics discussed in today's class
-----------------------------------------

1. significance of .tfvars
2. significance of output.tf
3. terraform plan -var or terraform apply -var
4. Determine which value to apply if the  value is defined in multiple places (e.g., -var, variables.tf, and terraform.tfvars)
5. terraform plan -var-file <filename> or terraform apply -var-file <filename>
6. terraform fmt
7. terraform validate
----------------------------------------------------------------------------------
### Using -var in Terraform
The -var option in Terraform allows you to specify a value for a variable directly from the command line. This is useful when you want to override default values or don't want to manage variable values in separate files. The -var flag is typically used for one-off variable assignments or when you want to provide specific values without modifying configuration files.

#### Syntax:
```
terraform plan -var "variable_name=value"
terraform apply -var "variable_name=value"
```
-----------------------------------------------------------------------
### Using -var-file in Terraform
The -var-file option in Terraform allows you to specify an external file that contains the variable definitions, rather than passing them individually on the command line or hardcoding them in your Terraform configuration. This option is useful for separating variable values from the Terraform configuration and for organizing values for different environments (e.g., development, production).

#### Syntax: 
```
terraform plan -var-file="<filename>.tfvars"
terraform apply -var-file="<filename>.tfvars"
```
----------------------------------------------------------------------------------------
### The Significance of the terraform.tfvars 
The terraform.tfvars file in Terraform is a key mechanism used to define the values of variables in a Terraform configuration. It is often used to simplify and centralize the management of input variables that your configuration depends on.
#### When and Why to Use Them Together:
**Use** `variables.tf`: When you want to define the structure, types, and defaults for the variables you plan to use in your Terraform configuration. This makes your code more modular and reusable.

**Use** `terraform.tfvars`: When you want to override the default values of variables or specify different values for variables depending on the environment (e.g., dev, prod) or specific configurations.

###  Determine which value to apply if the  value is defined in multiple places (e.g., -var, variables.tf, and terraform.tfvars)

In Terraform, variables can be defined in multiple places. When you specify values for variables in multiple places, Terraform applies a particular order of precedence to determine which value to use. Here's how the variable assignment works:

1. -var: When you provide a variable value directly on the command line using the -var flag, it has the highest precedence.

2. -tfvars: If a .tfvars file is used, its values are applied after the command-line -var flag but before the variable.tf or main.tf.

3. variable.tf: This file contains the default values for the variables. If none of the other sources specify a value, the default value from variable.tf will be used.

#### Precedence Order
| Precedence Order | Source                  | Example Key Value   |
|-------------------|-------------------------|---------------------|
| 1                 | Command Line (`-var`)  | `cli-key`          |
| 2                 | Variable File (`.tfvars`) | `tfvars-key`     |
| 3                 | Default (`variables.tf`) | `default-key`     |

----------------------------------------------------------------------------------------------
### output.tf in Terraform
output.tf: The output.tf file in Terraform is used to define output values, which are values you want to display after applying your Terraform configuration. These values are helpful for sharing important information (like instance IDs, IP addresses, or DNS names) from your infrastructure setup.

#### Structure of output.tf:
```
output "<output_name>" {
      value       = <value>
      description = "<description>" # Optional
      sensitive   = <true/false>    # Optional
}
```

Example:
```
output "instance_public_ip" {
  value       = aws_instance.my_instance.public_ip
  description = "The public IP of the EC2 instance"
}
```

------------------------------------------------------------------------------------------
### Using terraform fmt to Format Terraform Code
The terraform fmt command automatically formats Terraform configuration files (.tf files) according to the official Terraform style guide. This ensures that your code is consistent, readable, and follows best practices for indentation, alignment, and structure.

#### Command:
```
terraform fmt
```
--------------------------------------------------------------------------------------------
### Using terraform validate to Validate Terraform Configuration
The terraform validate command is used to check the syntax and configuration of your Terraform files to ensure they are correct before applying them. It helps identify common errors in the Terraform configuration such as missing or incorrect resource definitions, invalid references, or incorrect variable types. However, it does not interact with the actual cloud provider or create infrastructure—its sole purpose is to validate the configuration files.


#### Command: 
```
terraform validate
```
------------------------------------------------------------------------
Please refer to anoter document "Understanding tfvars and output.docX" for more details
----------------------------------------------------------------------------