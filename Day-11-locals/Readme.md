### Locals in Terraform
The `locals` block in Terraform is used to define expressions or values that are calculated and reused throughout your configuration. Locals help improve the readability and maintainability of Terraform code by allowing you to define reusable constants or expressions.

### Syntax
```
locals {
  variable_name = <expression>
  another_var   = <expression>
}
```
- `variable_name`: Name of the local variable.  
- `<expression>`: The value or logic for the local.  

## Terraform: Locals vs Variables  

| Feature            | **Locals**                                                     | **Variables**                                                   |
|--------------------|----------------------------------------------------------------|----------------------------------------------------------------|
| **Purpose**        | Define reusable, computed values or constants within the configuration. | Accept user input dynamically to customize configuration.      |
| **Scope**          | Limited to the current module.                                 | Defined in a module but values are provided externally.         |
| **Value Source**   | Values are hardcoded or derived within the configuration.      | Values are provided by users, CLI arguments, or `.tfvars` files. |
| **Usage**          | Ideal for computed values, repeated logic, or internal constants. | Ideal for environment-specific or user-defined input values.    |
| **Mutability**     | Immutable after being defined.                                 | Can change dynamically between executions.                     |
| **Access Syntax**  | Referenced as `local.<name>`.                                  | Referenced as `var.<name>`.                                     |
| **Declaration**    | Inside a `locals` block.                                       | Inside a `variable` block.                                      |