locals {
  tags = merge(
    {
      # Required
      Environment  = var.environment == "prd" ? "Prod" : title(var.environment)
      Criticality  = "High"
      BusinessUnit = "Infrastructure"
      Owner        = "infrastructure@version1.com"
      CostCenter   = "Platform"
      Application  = "Azure-Landing-Zone"
      OpsTeam      = "Cloud-Operations"

      # Optional
      Reposiotry = "caf-tf-az-infra-core"
      Project    = "CAF"
    },
    var.tags
  )
}
