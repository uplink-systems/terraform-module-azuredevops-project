## Module 'terraform-module-azuredevops-project'

> [!NOTE]  
> The **terraform-module-azuredevops-project** module has known issues **without** impact on the module's functionality. 

### Description

The module **terraform-module-azuredevops-project** manages Azure DevOps projects resources following my business needs and standards. This includes the project itself as well as some dependant resources like pipeline settings and project-wide repository policies.  
It follows these guidelines:  
* Project names can only contain the following characters: 0-9, a-z, A-Z and -  
* Project are always named as one of (depending in which of Uplink Systems' AzDO organization the project is created):  
  * EXT organization: Customer Number to which the repositories will be created for  
  * INT organization: <i>&lt;Project-Type&gt;</i>-<i>&lt;Project-Scope/Project-Purpose&gt;</i>, examples:  
    * Docu-Infrastruture --> Project to document infrastructure(s)  
    * DEV-Staging-INT --> Project for internal developments in staging phase ("playground" repository)  
    * IaC-Terraform --> Project for Infrastructure(s)-as-Code using Terraform  
* Projects' default settings are (changes can be configured via module's variables):  
  * enabled features are "Boards" and "Repositories"  
  * work item templaty is "Agile"  
  * visibility is "private"  
  * version control is "Git  
* Repository policies are not configured on project level by default but can be enabled.  

> [!NOTE]  
> A default (uninitialized) repository and a default team are automatically generated when the project itself is created. The module contains two data sources to output the team- and repository-attributes from the module as well as two formatted outputs to use as import Ids. Furthermore, the module manages the administrators of the default team. If no administrator config is passed to the module, a default configuration applies adding the "Project Administrators" group as administrators.  
> For further info and why/how to make use of the output or not: see "Known Issues".  

### Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.9.0 |
| <a name="requirement_powershell"></a> [powershell](#requirement\_powershell) | >= 7.0 |
| <a name="requirement_azuredevops"></a> [microsoft\/azuredevops](#requirement\_azuredevops) | ~> 1.9 |

### Resources

| Name | Type |
|------|------|
| [azuredevops_project.project](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/resources/project) | resource |
| [azuredevops_group_membership.project_administrators](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/resources/group_membership) | resource |
| [azuredevops_team_administrators.team_administrators](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/resources/team_administrators) | resource |
| [azuredevops_project_pipeline_settings.project_pipeline_settings](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/resources/project_pipeline_settings) | resource |
| [azuredevops_repository_policy_author_email_pattern.author_email_pattern](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/resources/repository_policy_author_email_pattern) | resource |
| [azuredevops_repository_policy_case_enforcement.case_enforcement](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/resources/repository_policy_case_enforcement) | resource |
| [azuredevops_repository_policy_check_credentials.check_credentials](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/resources/repository_policy_check_credentials) | resource |
| [azuredevops_repository_policy_file_path_pattern.file_path_pattern](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/resources/repository_policy_file_path_pattern) | resource |
| [azuredevops_repository_policy_max_file_size.max_file_size](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/resources/repository_policy_max_file_size) | resource |
| [azuredevops_repository_policy_max_path_length.max_path_length](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/resources/repository_policy_max_path_length) | resource |
| [azuredevops_repository_policy_reserved_names.reserved_names](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/resources/repository_policy_reserved_names) | resource |
| [terraform_data.initialize_default_repository](https://developer.hashicorp.com/terraform/language/resources/terraform-data) | managed resource |
| [terraform_data.disable_default_repository](https://developer.hashicorp.com/terraform/language/resources/terraform-data) | managed resource |
| [terraform_data.enable_default_repository](https://developer.hashicorp.com/terraform/language/resources/terraform-data) | managed resource |

### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_organization"></a> [organization](#input\_organization) | organization's main variable with attributes required for the project's resources | <pre>type        = object({<br>  personal_access_token   = string<br>})<br></pre> | none | yes |
| <a name="input_project"></a> [project](#input\_project) | project main variable with resource attributes | <pre>type        = object({<br>  name                    = string<br>  description             = optional(string, null)<br>  features                = optional(object({<br>    artifacts               = optional(string, "disabled")<br>    boards                  = optional(string, "enabled")<br>    repositories            = optional(string, "enabled")<br>    pipelines               = optional(string, "disabled")<br>    testplans               = optional(string, "disabled")<br>  }), {})<br>  visibility              = optional(string, "private")<br>  version_control         = optional(string, "Git")<br>  work_item_template      = optional(string, "Agile")<br>  project_administrators  = optional(object({<br>    users                   = optional(list(string), null)<br>    mode                    = optional(string, "overwrite")<br>  }), {})<br>  disable_default_repository  = optional(bool, false)<br>  enable_default_repository  = optional(bool, false)<br>})</pre> | none | yes |
| <a name="input_team_administrators"></a> [team\_administrators](#input\_team\_administrators) | project's default team administrators | <pre>object({<br>  name = optional(list(string), ["Project Administrators"])<br>  mode = optional(string, "overwrite")<br>})</pre> | <pre>name = ["Project Administrators"]<br>mode = "overwrite"</pre> | no |
| <a name="input_project_pipeline_settings"></a> [team\_project\_pipeline\_settings](#input\_project\_pipeline\_settings) | project's pipeline settings | <pre>type        = object({<br>  enforce_job_scope                     = optional(bool, true)<br>  enforce_job_scope_for_release         = optional(bool, true)<br>  enforce_referenced_repo_scoped_token  = optional(bool, true)<br>  enforce_settable_var                  = optional(bool, true)<br>  publish_pipeline_metadata             = optional(bool, false)<br>  status_badges_are_private             = optional(bool, true)<br>})<br></pre> | <pre>enforce_job_scope                     = true<br>enforce_job_scope_for_release         = true<br>enforce_referenced_repo_scoped_token  = true<br>enforce_settable_var                  = true<br>publish_pipeline_metadata             = false<br>status_badges_are_private             = true</pre> | no |
| <a name="input_repository_policy"></a> [repository\_policy](#input\_repository\_policy) | repository_policy main variable with resource attributes for project-level policies | <pre>type        = object({<br>  project_id            = string<br>  repository_ids        = optional(list(string), null)<br>  author_email_pattern  = optional(object({<br>    enabled                 = optional(bool, true)<br>    blocking                = optional(bool, true)<br>    author_email_patterns   = list(string)<br>  }), {<br>    enabled                 = false<br>    author_email_patterns   = ["\*@example.code"]<br>  })<br>  case_enforcment       = optional(object({<br>    enabled                 = optional(bool, true)<br>    blocking                = optional(bool, true)<br>    enforce_consistent_case = optional(bool, true)<br>  }), {<br>    enabled                 = false<br>    enforce_consistent_case = false<br>  })<br>  file_path_pattern     = optional(object({<br>    enabled                 = optional(bool, true)<br>    blocking                = optional(bool, true)<br>    file_path_patterns      = list(string)<br>  }), {<br>    enabled                 = false<br>    file_path_patterns      = ["example.code","/code/\*.example"]<br>  })<br>  max_file_size         = optional(object({<br>    enabled                 = optional(bool, true)<br>    blocking                = optional(bool, true)<br>    max_file_size           = optional(number, 10)<br>  }), { enabled = false })<br>  max_path_length       = optional(object({<br>    enabled                 = optional(bool, true)<br>    blocking                = optional(bool, true)<br>    max_path_length         = optional(number, 1000)<br>  }), { enabled = false })<br>  reserved_names        = optional(object({<br>    enabled                 = optional(bool, true)<br>    blocking                = optional(bool, true)<br>  }), { enabled = false })<br>})</pre> | none | no |

### Outputs

| Name | Description |
|------|-------------|
| <a name="output_project"></a> [project](#output\_project) | list of all exported attributes values from the project resource |
| <a name="output_group_membership_project_administrators"></a> [group\_membership\_project\_administrators](#output\_group\_membership\_project\_administrators) | list of all exported attribute values from the group_membership.project_administrators resource |
| <a name="output_project_pipeline_settings"></a> [project\_pipeline\_settings](#output\_project\_pipeline\_settings) | list of all exported attributes values from the project_pipeline_settings resource |
| <a name="output_repository_policy_author_email_pattern"></a> [repository\_policy\_author\_email\_pattern](#output\_repository\_policy\_author\_email\_pattern) | list of all exported attributes values from the repository_policy_author_email_pattern resource |
| <a name="output_repository_policy_case_enforcement"></a> [repository\_policy\_case\_enforcement](#output\_repository\_policy\_case\_enforcement) | list of all exported attributes values from the repository_policy_case_enforcement resource |
| <a name="output_repository_policy_file_path_pattern"></a> [repository\_policy\_file\_path\_pattern](#output\_repository\_policy\_file\_path\_pattern) | list of all exported attributes values from the repository_policy_file_path_pattern resource |
| <a name="output_repository_policy_max_file_size"></a> [repository\_policy\_max\_file\_size](#output\_repository\_policy\_max\_file\_size) | list of all exported attributes values from the repository_policy_max_file_size resource |
| <a name="output_repository_policy_max_path_length"></a> [repository\_policy\_max\_path\_length](#output\_repository\_policy\_max\_path\_length) | list of all exported attributes values from the repository_policy_max_path_length resource |
| <a name="output_repository_policy_reserved_names"></a> [repository\_policy\_reserved\_names](#output\_repository\_policy\_reserved\_names) | list of all exported attributes values from the repository_policy_reserved_names resource |
| <a name="output_team"></a> [team](#output\_team) | list of all exported attributes values from the (project's default) team resource |
| <a name="output_git_repository"></a> [git\_repository](#output\_git\_repository) | list of all exported attributes values from the (project's default) git_repository resource |
| <a name="output_import_id_team"></a> [import\_id\_team](#output\_import\_id\_team) | formatted id needed to import the team resource to Terraform state |
| <a name="output_import_id_git_repository"></a> [import\_id\_git\_repository](#output\_import\_id\_git\_repository) | formatted id needed to import the git_resource resource to Terraform state |

### Known Issues

Known issues are documented with the GitHub repo's issues functionality. Please filter the issues by **Types** and select **Known Issue** to get the appropriate issues and read the results carefully before using the module to avoid negative impacts on your infrastructure.  
  
<a name="known_issues"></a> [list of Known Issues](https://github.com/uplink-systems/terraform-module-azuredevops-project/issues?q=type%3A%22known%20issue%22)