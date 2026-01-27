data "azurerm_billing_enrollment_account_scope" "main" {
  count = var.subscriptions == null ? 0 : 1

  billing_account_name    = var.subscriptions.billing_account_name
  enrollment_account_name = var.subscriptions.enrollment_account_name
}

resource "azurerm_subscription" "main" {
  for_each = var.subscriptions == null ? {} : { for sub in var.subscriptions.subscriptions : sub.name => sub }

  subscription_name = each.value.name
  alias             = each.value.alias
  billing_scope_id  = data.azurerm_billing_enrollment_account_scope.main[0].id

  tags = local.tags
}
