Topics discussed in today's class
-----------------------------------------
1. Manual updates on the console are overridden by terraform apply
2. Manually updating the state file is overridden by terraform apply
3. Deleting the state file resets the environment to its initial state
4. Developers working independently without a backend.tf file
5. Collaborative workflows using a backend.tf configuration
6. Code in .tf is modified but terraform apply is not run
----------------------------------------------------------------------------------
### Case 1: Manual updates on the console are overridden by terraform apply
If manual changes are made directly in the cloud console (e.g., adding or modifying resources), `terraform apply` will override these changes when it is run. This is because Terraform compares the current state with the desired state defined in the `.tf` files, and any manual updates that deviate from this will be corrected.

```
1. Initial State:
   Terraform Configuration (.tf file): Name = "web-server"
   State File (terraform.tfstate): Name = "web-server"
   AWS EC2 Instance: Name = "web-server"

2. Manual Update:
   AWS EC2 Instance: Name manually updated to "db-server"

3. After Running `terraform apply`:
   Terraform Configuration (.tf file): Name = "web-server"
   State File (terraform.tfstate): Name = "web-server"
   AWS EC2 Instance: Name restored to "web-server"
```
### Case 2: Manually updating the state file is overridden by terraform apply
Directly modifying the Terraform state file (`terraform.tfstate`) outside of Terraform can lead to inconsistencies. When `terraform apply` is executed, it reads the actual cloud infrastructure and compares it with the state file, overriding any manual changes made to the state file.

```
1. Initial State:
   Terraform Configuration (.tf file): Name = "web-server"
   State File (terraform.tfstate): Name = "web-server"
   AWS EC2 Instance: Name = "web-server"

2. Manual Update:
   State File (terraform.tfstate): Name updated to "db-server"

3. After Running `terraform apply`:
   Terraform Configuration (.tf file): Name = "web-server"
   State File (terraform.tfstate): Name restored to "web-server"
   AWS EC2 Instance: Name remains "web-server"
```
### Case 3: Deleting the state file resets the environment to its initial state
If the state file is deleted, Terraform will lose the information about the existing resources. On the next `terraform apply`, it will treat the environment as new, attempting to create all resources as defined in the `.tf` files, essentially resetting the environment to its initial state.
```
1. Initial State:
   Terraform Configuration (.tf file): Name = "web-server"
   State File (terraform.tfstate): Name = "web-server"
   AWS EC2 Instance: Name = "web-server"

2. Delete State File:
   terraform.tfstate is deleted.

3. After Running `terraform apply`:
   Terraform Configuration (.tf file): Name = "web-server"
   State File (terraform.tfstate): Newly created with Name = "web-server"
   AWS EC2 Instance: A new instance is created with Name = "web-server"
```
### Case 4: Developers working independently without a backend.tf file
When developers work independently without using a `backend.tf` file, each developer manages their own local state file. This can lead to inconsistencies between environments, as there is no shared remote backend to synchronize the state.

```
1. Developer A’s Environment:
   Terraform Configuration (.tf file): Name = "web-server"
   State File (terraform.tfstate): Local to Developer A
   AWS EC2 Instance: Name = "web-server"

2. Developer B’s Environment:
   Terraform Configuration (.tf file): Name = "web-server"
   State File (terraform.tfstate): Local to Developer B
   AWS EC2 Instance: Name = "web-server"

Result:
   Two EC2 instances with the same configuration are created independently,
   leading to duplication and inconsistencies.
```
### Case 5: Collaborative workflows using a backend.tf configuration
In a collaborative workflow, developers use a `backend.tf`file to configure a shared remote backend (like AWS S3 or HashiCorp Consul) to store the Terraform state. This ensures that all developers are working with the same state and prevents conflicts from manual or local changes.

```
1. Initial Setup:
   Terraform Configuration (.tf file): Name = "web-server"
   State File: Stored in a centralized backend (e.g., S3 bucket)

2. Developer A:
   Runs `terraform apply` to create an EC2 instance.
   Terraform Configuration: Name = "web-server"
   AWS EC2 Instance: Name = "web-server"
   State File: Updated in the centralized backend.

3. Developer B:
   Pulls the centralized state.
   Runs `terraform plan`.
   Finds no changes, ensuring consistency.

Result:
   Centralized state file prevents duplication and ensures collaboration.
```
### Case 6: Code in .tf is modified but terraform apply is not run
If the code in the `.tf` files is modified (e.g., changing the tag to `Name=db-server`) but terraform apply is not run, the changes will not be applied to the infrastructure. In this case, Developer 2 runs `terraform plan` and realizes there is an out-of-sync issue between the current infrastructure and the desired configuration in the `.tf` files. The terraform plan command shows a discrepancy, highlighting that the infrastructure does not match the desired state (because `terraform apply` has not been executed to apply the changes).

```
1. Initial State:
   Terraform Configuration (.tf file): Name = "web-server"
   State File (terraform.tfstate): Name = "web-server"
   AWS EC2 Instance: Name = "web-server"

2. User A Modifies `.tf` File:
   Terraform Configuration (.tf file): Name = "db-server"
   (No `terraform apply` is run; state and infrastructure remain unchanged.)

3. User B Runs `terraform plan`:
   Output: 
      ~ aws_instance.example
        tags.Name: "web-server" => "db-server"

4. Options for User B:
   a. Run `terraform apply` to update infrastructure and state to match the `.tf` file.
   b. Revert the `.tf` file if the changes were unintentional.

Result:
   Discrepancy detected between `.tf` file and state, prompting reconciliation.
```


------------------------------------------------------------------------
Please refer to anoter document "Understanding Terraform State: Overrides, Collaboration, and Workflow.docX" for more details
----------------------------------------------------------------------------