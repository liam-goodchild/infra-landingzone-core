provider "alz" {
  library_overwrite_enabled = true
  library_references = [
    {
      "path" : "platform/alz",
      "ref" : "2025.09.3"
    },
    {
      custom_url = "${path.root}/lib"
    }
  ]
}

provider "azurerm" {
  features {}
}

provider "azapi" {}

provider "azuread" {}
