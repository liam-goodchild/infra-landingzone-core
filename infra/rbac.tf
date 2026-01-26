resource "azuread_group" "main" {
  for_each = { for group in var.rbac_groups : group.name => group }

  display_name     = "${replace(local.prefix, "-", "_")}_${each.value.name}"
  mail_enabled     = false
  security_enabled = true
}

resource "azurerm_role_assignment" "main" {
  for_each = { for item in flatten([
    for group in var.rbac_groups : [
      for role in group.role_definitions : {
        group_name           = group.name
        role_definition_name = role
      }
    ]
  ]) : "${item.group_name}_${item.role_definition_name}" => item }

  scope                = "/subscriptions/${data.azurerm_client_config.current.subscription_id}"
  role_definition_name = each.value.role_definition_name
  principal_id         = azuread_group.main[each.value.group_name].object_id
}

resource "azuread_group_member" "main" {
  for_each = { for item in flatten([
    for group in var.rbac_groups : [
      for group_member in group.group_members_names : {
        group_name        = group.name
        group_member_name = group_member
      }
    ]
  ]) : "${item.group_name}_${item.group_member_name}" => item }

  group_object_id  = azuread_group.main[each.value.group_name].object_id
  member_object_id = data.azuread_group.main[each.value.group_member_name].object_id
}