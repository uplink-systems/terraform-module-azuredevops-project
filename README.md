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

#### Tasks & ToDos

- [x] Create and manage a project with default team and git repository
- [x] Add and manage project pipeline settings to the project
- [x] Add and manage repository policies on project level
- [x] Manage default team's administrators using groups
- [x] Manage "Project Administrators" group membership
- [x] Initialize the project's default repository (via AzDO REST API call)
- [x] Opt-in to skip initialization of the project's default repository for imported projects
- [x] Opt-in to disable/enable the project's default repository (via AzDO REST API calls)
- [x] \(Optional) Apply input variable validation rules if necessary to match available resource values
- [x] \(Optional) Apply input variable validation rules if necessary to match the business standards
- [x] Create and manage modules outputs
- [x] Document module with README.md
- [ ] \(Optional) Review code regularly for possible improvements and updates

### Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.9.0 |
| <a name="requirement_powershell"></a> [powershell](#requirement\_powershell) | >= 7.0 |
| <a name="requirement_azuredevops"></a> [microsoft\/azuredevops](#requirement\_azuredevops) | ~> 1.5 |

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

<details>
<summary><b>Default <i>git_repository</i> resource automatically created with a project</b></summary>

######
A new created project in Azure Devops automatically generates an uninitialized repository labeled as <i>&lt;name of project&gt;</i>. This is by design and can't be suppressed.  
  
The module initializes the default repository but if it shall or need to be managed afterwards, it needs to be imported. The *project* module provides explicit output to use as import source but in most cases it is not necessary to further change repository settings.  

Optionally it is possible to disable the repository. This can be done by setting the variable *disable_default_repository* to *true*.  

If an import is necessary one can use the following code snippet:

```
import {
  id = module.<project-module-name>.import_id_git_repository
  to = module.<git-repository-module-name>.azuredevops_git_repository.git_repository
}
```

If the default repository has been imported into Terraform state, deleting a project via *terraform destroy* command will fail. This is also by design because the default repository resource cannot be deleted on its own but has to be deleted via the project resource. Remove the imported resource manually from Terraform state before executing the destroy-command to workaround this:  

```
terraform state rm module.<git-repository-module-name>.azuredevops_git_repository.git_repository
```

</details>

<details>
<summary><b>Default <i>team</i> resource automatically created with a project</b></summary>

######
A new created project in Azure Devops automatically generates a default team labeled as <i>&lt;name of project&gt; Team</i>. This is by design and can't be suppressed.  
  
If the default resource shall or need to be used, it can only be managed if it is imported. The *project* module provides explicit output to use as import source.  

The *azuredevops_team* resource can only manage the team's name, description, administrators and members. Name and description should not be changed for the default team. Administrators and members can be managed using *azuredevops_team_administrators* and *azuredevops_team_members* resources. Therefore, it is not necessary to import the team into Terraform state.  

If an import is needed one can use the following code snippet:

```
import {
  id = module.<project-module-name>.import_id_team
  to = module.<team-module-name>.azuredevops_team.team
}
```

If the default team has been imported into Terraform state, deleting a project via *terraform destroy* command will fail. This is also by design because the default team resource cannot be deleted on their own but has to be deleted via the project resource. Remove the imported resource manually from Terraform state before executing the destroy-command to workaround this:  

```
terraform state rm module.<team-module-name>.azuredevops_team.team
```

</details>

<details>
<summary><b>Initialize the default repository</b></summary>

######
The module contains an option to initialize the automatically generated default repository which is enabled by default. It is triggered via *var.project.initialize_default_repository* variable attribute.  

Setting the *var.project.initialize_default_repository* value to *false* skips the init process. This can be useful for example if the project resource is an imported resource. In this case the init should be disabled to prevent the module from accidentially deleting or overwriting exisiting resources.  
  
Please note:  
**DO NOT** change the *var.project.initialize_default_repository* value **after** the code for the resource has been applied for the first time. This can lead to unexpected results and even to data loss.  

</details>

<details>
<summary><b>Disable or enable the default repository</b></summary>

######
The module contains an option to disable/enable the automatically generated default repository. It is triggered via *var.project.disable_default_repository* and *var.project.enable_default_repository* variable attributes.

Setting the *var.project.disable_default_repository* value to *true* triggers the resource *terraform_data.disable_default_repository* and disables the repository whereas setting the attribute's value to *false* or unset the attribute's value only destroys the resource from state but **NOT** enable the repository again.  
Setting the *var.project.enable_default_repository* value to *true* triggers the resource *terraform_data.enable_default_repository* and enables the repository whereas setting the attribute's value to *false* or unset the attribute's value only destroys the resource from state but **NOT** disable the repository again.
This "double-resource" procedure is necessary because the option is implemented using *local-exec* provisioner with PowerShell which can only execute kind of **one-way** commands and does not have a "rollback" option.  
  
Setting *both* attributes to *true* causes the module to stop as it has a validation rule to prevent conflicts for these attributes.

</details>
