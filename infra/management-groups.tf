module "alz_architecture" {
  source  = "Azure/avm-ptn-alz/azurerm"
  version = "0.12.0"

  architecture_name      = var.deploy_caf_policies ? "base-policies" : "base"
  parent_resource_id     = data.azapi_client_config.current.tenant_id
  location               = var.location
  enable_telemetry       = var.enable_telemetry
  subscription_placement = local.subscription_placement
}
