variable "location" {
  type        = string
  description = "Resource location for Azure resources."
}

variable "tags" {
  type        = map(string)
  description = "Environment tags."
}

variable "environment" {
  type        = string
  description = "Name of Azure environment."
}

variable "project" {
  type        = string
  description = "Project short name."
}

variable "enable_telemetry" {
  type        = bool
  default     = true
  description = "Enable telemetry for the module."
  nullable    = false
}

variable "deploy_caf_policies" {
  type        = bool
  default     = false
  description = "Deploy CAF policies in addition to the management group hierarchy. When false, only the hierarchy is deployed."
}

variable "subscriptions" {
  description = "Azure Subscriptions to create."
  type = object({
    billing_account_name    = string
    enrollment_account_name = string
    subscriptions = list(object({
      name                       = string
      alias                      = optional(string)
      parent_management_group_id = string
    }))
  })
  default = null
}

variable "rbac_groups" {
  description = "Groups RBAC Configuration."
  type = list(object({
    name                = string
    group_members_names = optional(list(string))
    role_definitions    = optional(list(string))
  }))
}

variable "management_group_subscriptions" {
  description = "Subscriptions to place into management groups (one MG can have many subscriptions)."
  type = list(object({
    id               = string
    subscription_ids = list(string)
  }))
  default = []
}
