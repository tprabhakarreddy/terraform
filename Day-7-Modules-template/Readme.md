### Topics covered in today's class
1. Use local template in modules 
2. Use Own Repository Template in Modules
3. Use Repository template from Official Terraform GitHub in Modules

------------------------------------------------------------------------------------------
### Modules in Terraform
A **module** in Terraform is a container for multiple resources that are used together. Modules are a way to organize and reuse infrastructure code, making configurations more manageable, scalable, and consistent.

**Structure of a Module**
A module typically contains these files:  
- `main.tf`: Defines the resources and logic.  
- `variables.tf`: Declares input variables for the module.  
- `outputs.tf`: Defines outputs that can be used by the calling module.  
- `providers.tf`: Configures providers required by the module.  

-----------------------------------------------------------------------------------------

**How to Use a Module**
Modules are called using the `module` block, specifying the source and variables.

- **Example:** Using a local module:

```
module "example" {
  source    = "./modules/example"
  variable1 = "value1"
}
```
**Sources for Modules**
1. Local Path: source = "./modules/example"

2. Git Repository: source = "git::https://github.com/username/repo.git//module_path?ref=branch"

3. Terraform Registry: source = "terraform-aws-modules/vpc/aws"

-----------------------------------------------------------------------------------------
#### Brief Overview with Examples:

1. **Use Local Template in Modules**
Local templates are modules stored within your project directory, referenced using a relative path.

- **Example Directory Structure:**
```
project/
├── main.tf
├── modules/
│   └── my_module/
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
```

- **Usage in** `main.tf`:
```
module "local_module" {
  source    = "./modules/my_module"
  variable1 = "value1"
}
```
--------------------------------------------------------------------------------------
2. **Use Own Repository Template in Modules**
Custom templates are hosted in your private or public repository, allowing them to be reused across multiple projects.
-**Example Usage:**
```
module "repo_module" {
  source    = "git::https://github.com/username/repo_name.git//module_path?ref=main"
  variable1 = "value1"
}
```
--------------------------------------------------------------------------------------
3. **Use Repository Template from Official Terraform GitHub in Modules**
Use pre-built, well-maintained modules from Terraform's GitHub or Registry to simplify common setups.

- **Example (AWS VPC Module):**
```
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"

  name            = "my-vpc"
  cidr            = "10.0.0.0/16"
  azs             = ["us-east-1a", "us-east-1b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.3.0/24", "10.0.4.0/24"]
}
```
- **Use Case:** Perfect for leveraging standardized, community-tested modules for common infrastructure patterns.

---------------------------------------------------------------------------------------
#### Precedence Between Default Values and Passed Variables in Terraform Modules
In Terraform, if a variable has a default value defined in `variables.tf` and the same variable is also passed a value when calling the module, **the passed value will take precedence** over the default value.

**How it Works:**
- If a value is passed explicitly when calling the module, Terraform uses that value.
- If no value is passed, Terraform falls back to the default value defined in variables.tf.  