terraform {
  required_version = "<1.6.0, > 1.5.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
  }
}

provider "azurerm" {
  features {}

  tenant_id       = "cba533e6-d004-4e85-8d96-8f0a22c908a5"
  subscription_id = "0257ef73-2cbf-424a-af32-f3d41524e705"
}
