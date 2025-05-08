####################################################################################################
#   output.tf                                                                                      #
####################################################################################################

output "project" {
  description   = "project attributes"
  value         = azuredevops_project.project
  depends_on    = [ azuredevops_project.project ]
}

output "project_tags" {
  description   = "project tags attributes"
  value         = azuredevops_project_tags.project_tags
  depends_on    = [ azuredevops_project_tags.project_tags ]
}

output "group_membership_project_administrators" {
  description   = "group_membership.project_administrators attributes"
  value         = azuredevops_group_membership.project_administrators
  depends_on    = [ azuredevops_group_membership.project_administrators ]
}

output "project_pipeline_settings" {
  description   = "project_pipeline_settings attributes"
  value         = azuredevops_project_pipeline_settings.project_pipeline_settings
  depends_on    = [ azuredevops_project_pipeline_settings.project_pipeline_settings ]
}

output "repository_policy_author_email_pattern" {
    description = "author_email_pattern attributes"
    value       = azuredevops_repository_policy_author_email_pattern.author_email_pattern
    depends_on  = [ azuredevops_repository_policy_author_email_pattern.author_email_pattern ]
}

output "repository_policy_case_enforcement" {
    description = "case_enforcement attributes"
    value       = azuredevops_repository_policy_case_enforcement.case_enforcement
    depends_on  = [ azuredevops_repository_policy_case_enforcement.case_enforcement ]
}

output "repository_policy_file_path_pattern" {
    description = "file_path_pattern attributes"
    value       = azuredevops_repository_policy_file_path_pattern.file_path_pattern
    depends_on  = [ azuredevops_repository_policy_file_path_pattern.file_path_pattern ]
}

output "repository_policy_max_file_size" {
    description = "max_file_size attributes"
    value       = azuredevops_repository_policy_max_file_size.max_file_size
    depends_on  = [ azuredevops_repository_policy_max_file_size.max_file_size ]
}

output "repository_policy_max_path_length" {
    description = "max_path_length attributes"
    value       = azuredevops_repository_policy_max_path_length.max_path_length
    depends_on  = [ azuredevops_repository_policy_max_path_length.max_path_length ]
}

output "repository_policy_reserved_names" {
    description = "reserved_names attributes"
    value       = azuredevops_repository_policy_reserved_names.reserved_names
    depends_on  = [ azuredevops_repository_policy_reserved_names.reserved_names ]
}

output "team" {
  description   = "teams attributes"
  value         = data.azuredevops_team.team
  depends_on    = [ data.azuredevops_team.team ]
}

output "git_repository" {
  description   = "git_repository attributes"
  value         = data.azuredevops_git_repository.git_repository
  depends_on    = [ data.azuredevops_git_repository.git_repository ]
}

output "import_id_team" {
  description   = "formatted import id for automatically created team"
  value         = "${azuredevops_project.project.id}/${data.azuredevops_team.team.id}"
  depends_on    = [ azuredevops_project.project,data.azuredevops_team.team ]
}

output "import_id_git_repository" {
  description   = "formatted import id for automatically created git_repository"
  value         = "${azuredevops_project.project.id}/${data.azuredevops_git_repository.git_repository.id}"
  depends_on    = [ azuredevops_project.project,data.azuredevops_git_repository.git_repository ]
}
