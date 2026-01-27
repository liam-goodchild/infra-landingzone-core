# Azure Landing Zone Core Infrastructure

This repository contains the Terraform configuration and CI/CD pipelines to deploy the core components of the Microsoft Cloud Adoption Framework (CAF) Platform in Azure, including management group hierarchies, subscription management, governance policies, and RBAC configuration.

## Purpose

This repository provides a standardised, enterprise-grade foundation for Azure landing zone deployments using Infrastructure as Code principles.

- **Governance at Scale**: Deploys a CAF-aligned management group hierarchy with consistent policy enforcement across all subscriptions
- **Compliance Automation**: Enforces organisational standards through Azure Policy, including mandatory resource tagging
- **Identity Management**: Provisions Azure AD groups and role assignments as code for consistent access control
- **Repeatable Deployments**: Leverages Azure Verified Modules (AVM) for reliable, tested infrastructure patterns
- **Integrated CI/CD**: Provides automated validation, planning, and deployment through Azure DevOps pipelines

---

## Architecture Overview

This solution deploys a hierarchical management group structure following Microsoft's Cloud Adoption Framework best practices:

```
sky-haven (Root)
├── platform/
│   ├── connectivity          # Network resources
│   ├── identity              # Identity management
│   ├── management            # Operational management
│   ├── security              # Security controls
│   └── shared                # Shared platform resources
├── landing-zones             # Workload subscriptions
├── decommissioned            # Retired resources
└── sandbox                   # Non-production testing
```

### Key Components

| Component         | Description                                                       |
| ----------------- | ----------------------------------------------------------------- |
| Management Groups | CAF-aligned hierarchy for policy inheritance and access control   |
| Azure Policies    | Custom and built-in policies for governance enforcement           |
| RBAC Groups       | Azure AD groups with subscription-scoped role assignments         |
| Subscriptions     | Programmatic subscription creation and management group placement |

---

## Repository Structure

```
infra-landingzone-core/
├── .azuredevops/                    # CI/CD pipeline definitions
│   ├── ci-terraform.yaml            # Pull request validation
│   ├── cd-terraform.yaml            # Production deployment
│   ├── destroy-terraform.yaml       # Resource destruction
│   ├── dev-terraform.yaml           # Development testing
│   └── linters/                     # Code quality configuration
├── infra/                           # Terraform configuration
│   ├── _providers.tf                # Provider configuration
│   ├── _terraform.tf                # Version and backend setup
│   ├── _variables.tf                # Input variable definitions
│   ├── _locals.tf                   # Local value calculations
│   ├── _data.tf                     # Data source references
│   ├── _tags.tf                     # Common tagging standards
│   ├── management-groups.tf         # ALZ module invocation
│   ├── rbac.tf                      # Identity and access control
│   ├── subscriptions.tf             # Subscription lifecycle
│   ├── lib/                         # ALZ library customisations
│   │   ├── policy_definitions/      # Custom policy definitions
│   │   ├── policy_assignments/      # Policy-to-scope mappings
│   │   ├── archetype_definitions/   # Reusable policy bundles
│   │   └── architecture_definitions/# Management group templates
│   └── vars/                        # Variable files
│       ├── globals.tfvars           # Global settings
│       └── uks/                     # Regional configuration
│           └── prd.tfvars           # Production variables
└── README.md
```

For detailed information on ALZ library customisation, see [infra/lib/readme.md](infra/lib/README.md).

---

## Environments

| Environment | Region   | Description           |
| ----------- | -------- | --------------------- |
| `prd`       | UK South | Production deployment |

---

## Configuration

### Policy Deployment

The `deploy_caf_policies` variable controls policy deployment:

| Value   | Behaviour                                                     |
| ------- | ------------------------------------------------------------- |
| `false` | Deploys management group hierarchy only                       |
| `true`  | Deploys full CAF policy framework with governance enforcement |

### Required Tags

When CAF policies are enabled, the following tags are enforced across all resources:

| Tag            | Description            | Example Values                                       |
| -------------- | ---------------------- | ---------------------------------------------------- |
| `Environment`  | Deployment environment | Dev, Test, UAT, Staging, PreProd, Prod, PoC, Sandbox |
| `Criticality`  | Business criticality   | Low, Medium, High, Mission-Critical                  |
| `BusinessUnit` | Owning business unit   | Any value                                            |
| `Owner`        | Resource owner         | Email address                                        |
| `CostCenter`   | Cost allocation code   | Any value                                            |
| `Application`  | Application name       | Any value                                            |
| `OpsTeam`      | Operations team        | Any value                                            |

### RBAC Configuration

Azure AD groups are created with the following pattern: `{prefix}_{group_name}`

Default groups provisioned:

- **Owner**: Full administrative access
- **Contributor**: Resource modification access
- **Reader**: Read-only access

---

## Pipelines

| Pipeline | File                                                          | Trigger                | Description                            |
| -------- | ------------------------------------------------------------- | ---------------------- | -------------------------------------- |
| CI       | [ci-terraform.yaml](.azuredevops/ci-terraform.yaml)           | Pull request to `main` | Linting, documentation, terraform plan |
| CD       | [cd-terraform.yaml](.azuredevops/cd-terraform.yaml)           | Merge to `main`        | Plan, apply, and optional versioning   |
| Destroy  | [destroy-terraform.yaml](.azuredevops/destroy-terraform.yaml) | Manual                 | Controlled resource destruction        |
| Dev      | [dev-terraform.yaml](.azuredevops/dev-terraform.yaml)         | Manual                 | Development testing and validation     |

### CI Pipeline Stages

1. **Linting**: Prettier formatting and Checkov security scanning
2. **Documentation**: Auto-generates terraform-docs into readme
3. **Plan**: Creates and publishes terraform plan artifact

### CD Pipeline Stages

1. **Plan**: Validates changes against current state
2. **Apply**: Deploys validated changes to Azure
3. **Versioning**: Creates semantic version Git tags (optional)

---

## Development Workflow

> **Important**: This workflow must be followed exactly. Skipping steps can lead to broken environments, state corruption, or unsafe infrastructure changes.

This repository uses GitHub Flow with the following branch prefixes:

| Prefix       | Purpose          |
| ------------ | ---------------- |
| `feature/**` | New capabilities |
| `patch/**`   | Bugfixes         |
| `major/**`   | Breaking changes |

### Deployment Process

1. Create a branch from latest `main` using the appropriate prefix
2. Commit changes and open a Pull Request
3. CI pipeline automatically validates changes
4. Iterate until CI passes and team approves
5. Merge to `main` triggers CD pipeline
6. Changes are automatically deployed to production

---

## Quick Reference

### Prerequisites

- Terraform >= 1.0, < 2.0
- Azure CLI authenticated with appropriate permissions
- Azure DevOps service connection configured

### External Resources

- [Azure Landing Zones Library](https://azure.github.io/Azure-Landing-Zones-Library/)
- [AVM ALZ Module](https://registry.terraform.io/modules/Azure/avm-ptn-alz/azurerm/latest)
- [Microsoft Cloud Adoption Framework](https://learn.microsoft.com/azure/cloud-adoption-framework/)

---

## Summary

This repository provides a complete, policy-driven Azure landing zone foundation using Infrastructure as Code, enabling consistent governance, identity management, and subscription lifecycle control across the organisation.

---

<!-- prettier-ignore-start -->
<!-- textlint-disable -->
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0, < 2.0 |
| <a name="requirement_alz"></a> [alz](#requirement\_alz) | >= 0.17, < 1.0 |
| <a name="requirement_azapi"></a> [azapi](#requirement\_azapi) | >= 2.2, < 3.0 |
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | >= 3.0, < 4.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 4.0, < 5.0 |

## Resources

| Name | Type |
|------|------|
| [azuread_group.main](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/group) | resource |
| [azuread_group_member.main](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/group_member) | resource |
| [azurerm_role_assignment.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_subscription.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subscription) | resource |
| [azapi_client_config.current](https://registry.terraform.io/providers/azure/azapi/latest/docs/data-sources/client_config) | data source |
| [azuread_group.main](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/group) | data source |
| [azurerm_billing_enrollment_account_scope.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/billing_enrollment_account_scope) | data source |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_alz_architecture"></a> [alz\_architecture](#module\_alz\_architecture) | Azure/avm-ptn-alz/azurerm | 0.12.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_environment"></a> [environment](#input\_environment) | Name of Azure environment. | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | Resource location for Azure resources. | `string` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | Project short name. | `string` | n/a | yes |
| <a name="input_rbac_groups"></a> [rbac\_groups](#input\_rbac\_groups) | Groups RBAC Configuration. | <pre>list(object({<br/>    name                = string<br/>    group_members_names = optional(list(string))<br/>    role_definitions    = optional(list(string))<br/>  }))</pre> | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Environment tags. | `map(string)` | n/a | yes |
| <a name="input_deploy_caf_policies"></a> [deploy\_caf\_policies](#input\_deploy\_caf\_policies) | Deploy CAF policies in addition to the management group hierarchy. When false, only the hierarchy is deployed. | `bool` | `false` | no |
| <a name="input_enable_telemetry"></a> [enable\_telemetry](#input\_enable\_telemetry) | Enable telemetry for the module. | `bool` | `true` | no |
| <a name="input_management_group_subscriptions"></a> [management\_group\_subscriptions](#input\_management\_group\_subscriptions) | Subscriptions to place into management groups (one MG can have many subscriptions). | <pre>list(object({<br/>    id               = string<br/>    subscription_ids = list(string)<br/>  }))</pre> | `[]` | no |
| <a name="input_subscriptions"></a> [subscriptions](#input\_subscriptions) | Azure Subscriptions to create. | <pre>object({<br/>    billing_account_name    = string<br/>    enrollment_account_name = string<br/>    subscriptions = list(object({<br/>      name                       = string<br/>      alias                      = optional(string)<br/>      parent_management_group_id = string<br/>    }))<br/>  })</pre> | `null` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
<!-- textlint-enable -->
<!-- prettier-ignore-end -->
