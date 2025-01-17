### Terraform Workspaces
Terraform workspaces provide a mechanism to manage multiple states within the same configuration. By default, every Terraform configuration starts in the `default` workspace. Workspaces are commonly used for managing different environments (e.g., `development, staging, production`) within the same configuration directory.

### Common Commands  
- **List Workspaces:** `terraform workspace list`
- **Create a Workspace:** `terraform workspace new <workspace_name>`
- **Switch to a Workspace:** `terraform workspace select <workspace_name>`
- **Delete a Workspace:** `terraform workspace delete <workspace_name>`

