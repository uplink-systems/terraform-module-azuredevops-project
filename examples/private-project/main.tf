####################################################################################################
#   main.tf                                                                                        #
####################################################################################################

module "project_private" {
  source                      = "github.com/uplink-systems/terraform-module-azuredevops-project"
  project                     = {
    name                          = "Private-Project"
    project_administrators        = {
      users                                 = [
        "admin.azdo@tenantname.onmicrosoft.com",
      ]
    }
    project_pipeline_settings     = {
      enforce_job_scope                     = false
      enforce_job_scope_for_release         = false
      publish_pipeline_metadata             = true
    }
  }
}
