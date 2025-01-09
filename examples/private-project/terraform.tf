#################################################################################################### 
#   terraform.tf                                                                                   # 
####################################################################################################

terraform {
  required_version = "~> 1.9.0"
  required_providers {
    azuredevops = {
      source = "microsoft/azuredevops"
      version = "~> 1.5"
    }
  }
}