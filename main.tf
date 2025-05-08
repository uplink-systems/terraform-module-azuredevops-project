####################################################################################################
#   main.tf                                                                                        #
####################################################################################################

resource "azuredevops_project" "project" {
  name                = var.project.name
  description         = var.project.description
  features            = {
    artifacts           = var.project.features.artifacts
    boards              = var.project.features.boards
    repositories        = var.project.features.repositories
    pipelines           = var.project.features.pipelines
    testplans           = var.project.features.testplans
  }
  visibility          = var.project.visibility
  version_control     = var.project.version_control
  work_item_template  = var.project.work_item_template
}

resource "azuredevops_project_tags" "project_tags" {
  count               = var.project.tags != null ? 1 : 0
  project_id          = azuredevops_project.project.id
  tags                = var.project.tags
}

resource "azuredevops_group_membership" "project_administrators" {
  group               = data.azuredevops_group.project_administrators.descriptor
  members             = flatten(data.azuredevops_users.project_administrators[*].users[*].descriptor)
  mode                = var.project.project_administrators.mode
  depends_on          = [ azuredevops_project.project,data.azuredevops_group.project_administrators,data.azuredevops_users.project_administrators ]
}

resource "azuredevops_team_administrators" "team_administrators" {
  project_id          = azuredevops_project.project.id
  team_id             = data.azuredevops_team.team.id
  mode                = var.team_administrators.mode
  administrators      = data.azuredevops_group.team_administrators[*].descriptor
  depends_on          = [ data.azuredevops_group.team_administrators ]
}

resource "terraform_data" "initialize_default_repository" {
  count               = var.project.initialize_default_repository ? 1 : 0
  provisioner "local-exec" {
    command             = <<EOT
      $PersonalAccessTokenBase64  = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes(":${var.organization.personal_access_token}"))
      $Headers                    = @{"Authorization"="Basic $PersonalAccessTokenBase64"}
      $Uri                        = [string]::Format("${local.terraform_data.initialize_default_repository.uri}")
      $BodyAsJson                 = @"
{
  "refUpdates": [
    {
      "name": "refs/heads/main",
      "oldObjectId": "0000000000000000000000000000000000000000"
    }
  ],
  "commits": [
    {
      "comment": "Initial commit.",
      "changes": [
        {
          "changeType": "add",
          "item": {
            "path": "/README.md"
          },
          "newContent": {
            "content": "Terraform local-exec provisioner initiated commit and push",
            "contentType": "rawtext"
          }
        }
      ]
    }
  ]
}
"@
      $Result                     = Invoke-RestMethod -Uri $Uri -Method POST -Body $BodyAsJson -ContentType "application/json" -Headers $Headers
    EOT
    interpreter         = [ "pwsh", "-Command" ]
  }
  depends_on          = [ data.azuredevops_git_repository.git_repository, local.terraform_data ]
}

resource "terraform_data" "disable_default_repository" {
  count               = var.project.disable_default_repository ? 1 : 0
  provisioner "local-exec" {
    command             = <<EOT
      $PersonalAccessToken  = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes(":${var.organization.personal_access_token}"))
      $Headers              = @{"Authorization"="Basic $PersonalAccessToken"}
      $Uri                  = [string]::Format("${local.terraform_data.disable_default_repository.uri}")
      $BodyAsJson           = '{ "isDisabled" : "true" }'
      $Result               = Invoke-RestMethod -Uri $Uri -Method PATCH -Body $BodyAsJson -ContentType "application/json" -Headers $Headers
    EOT
    interpreter         = [ "pwsh", "-Command" ]
  }
  depends_on          = [ data.azuredevops_git_repository.git_repository, local.terraform_data, terraform_data.initialize_default_repository ]
}

resource "terraform_data" "enable_default_repository" {
  count               = var.project.enable_default_repository ? 1 : 0
  provisioner "local-exec" {
    command             = <<EOT
      $PersonalAccessToken  = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes(":${var.organization.personal_access_token}"))
      $Headers              = @{"Authorization"="Basic $PersonalAccessToken"}
      $Uri                  = [string]::Format("${local.terraform_data.enable_default_repository.uri}")
      $BodyAsJson           = '{ "isDisabled" : "false" }'
      $Result               = Invoke-RestMethod -Uri $Uri -Method PATCH -Body $BodyAsJson -ContentType "application/json" -Headers $Headers
    EOT
    interpreter         = [ "pwsh", "-Command" ]
  }
  depends_on          = [ data.azuredevops_git_repository.git_repository, local.terraform_data, terraform_data.initialize_default_repository ]
}

resource "azuredevops_project_pipeline_settings" "project_pipeline_settings" {
  project_id                            = azuredevops_project.project.id
  enforce_job_scope                     = var.project_pipeline_settings.enforce_job_scope
  enforce_job_scope_for_release         = var.project_pipeline_settings.enforce_job_scope_for_release
  enforce_referenced_repo_scoped_token  = var.project_pipeline_settings.enforce_referenced_repo_scoped_token
  enforce_settable_var                  = var.project_pipeline_settings.enforce_settable_var
  publish_pipeline_metadata             = var.project_pipeline_settings.publish_pipeline_metadata
  status_badges_are_private             = var.project_pipeline_settings.status_badges_are_private
  depends_on                            = [ azuredevops_project.project ]
}

resource "azuredevops_repository_policy_author_email_pattern" "author_email_pattern" {
  project_id                            = azuredevops_project.project.id
  enabled                               = var.repository_policy.author_email_pattern.enabled
  blocking                              = var.repository_policy.author_email_pattern.blocking
  author_email_patterns                 = var.repository_policy.author_email_pattern.author_email_patterns
  depends_on                            = [ azuredevops_project.project ]
}

resource "azuredevops_repository_policy_case_enforcement" "case_enforcement" {
  project_id                            = azuredevops_project.project.id
  enabled                               = var.repository_policy.case_enforcment.enabled
  blocking                              = var.repository_policy.case_enforcment.blocking
  enforce_consistent_case               = var.repository_policy.case_enforcment.enforce_consistent_case
  depends_on                            = [ azuredevops_project.project ]
}

resource "azuredevops_repository_policy_file_path_pattern" "file_path_pattern" {
  project_id                            = azuredevops_project.project.id
  enabled                               = var.repository_policy.file_path_pattern.enabled
  blocking                              = var.repository_policy.file_path_pattern.blocking
  filepath_patterns                     = var.repository_policy.file_path_pattern.file_path_patterns
  depends_on                            = [ azuredevops_project.project ]
}

resource "azuredevops_repository_policy_max_file_size" "max_file_size" {
  project_id                            = azuredevops_project.project.id
  enabled                               = var.repository_policy.max_file_size.enabled
  blocking                              = var.repository_policy.max_file_size.blocking
  max_file_size                         = var.repository_policy.max_file_size.max_file_size
  depends_on                            = [ azuredevops_project.project ]
}

resource "azuredevops_repository_policy_max_path_length" "max_path_length" {
  project_id                            = azuredevops_project.project.id
  enabled                               = var.repository_policy.max_path_length.enabled
  blocking                              = var.repository_policy.max_path_length.blocking
  max_path_length                       = var.repository_policy.max_path_length.max_path_length
  depends_on                            = [ azuredevops_project.project ]
}

resource "azuredevops_repository_policy_reserved_names" "reserved_names" {
  project_id                            = azuredevops_project.project.id
  enabled                               = var.repository_policy.reserved_names.enabled
  blocking                              = var.repository_policy.reserved_names.blocking
  depends_on                            = [ azuredevops_project.project ]
}
