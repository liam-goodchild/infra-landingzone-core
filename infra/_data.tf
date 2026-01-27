data "azurerm_client_config" "current" {}

data "azapi_client_config" "current" {}

data "azuread_group" "main" {
  for_each     = toset(local.distinct_group_names)
  display_name = each.value
}
