####################################################################################################
#   main.tf                                                                                        #
####################################################################################################

module "project_public" {
  source                      = "github.com/uplink-systems/terraform-module-azuredevops-project"
  project                     = {
    name                          = "Public-Project"
    visibility                    = "public"
    features                      = {
      boards                                = "disabled"
    }
    repository_policy             = {
      file_path_pattern                     = {
        file_path_patterns                      = [ "*.cmd","block.me" ]
      }
      max_file_size                         = {
        max_file_size                           = 20
      }
    }
    project_administrators        = {
      users                                 = [
        "admin.azdo@tenantname.onmicrosoft.com",
      ]
    }
  }
}
