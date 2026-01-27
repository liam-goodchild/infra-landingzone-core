# 📚 Azure Landing Zones Library

This repository contains Terraform configuration that leverages the [avm-ptn-alz](https://registry.terraform.io/modules/Azure/avm-ptn-alz/azurerm/latest) module to deploy Azure Management Groups and Azure CAF aligned policies.

The module integrates seamlessly with the [Azure Landing Zones Library](https://azure.github.io/Azure-Landing-Zones-Library/) to provide a consistent and scalable foundation.

This folder enables you to customise the module baseline setup, including defining a bespoke Management Group hierarchy and tailoring the policy assignments applied to each Management Group.

## 📁 Directory Structure

```
lib/
├── policy_definitions/       # Custom policy definition JSON files
├── policy_assignments/       # Policy assignment configuration JSON files
├── archetype_definitions/    # Archetype definitions with policy mappings
└── architecture_definitions/ # Management Group definitions with archetype mappings
```

## 📜 Policy Definitions

Azure policy definitions are the rules that govern how resources should be created and configured across your environment. They’re written in JSON and describe the conditions Azure should evaluate, such as required tags, allowed regions, or security settings and the action to take when those conditions aren’t met.

### Custom Policy Definitions

| Location                                                        | Description                                                                                                                                                             |
| --------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `policy_definitions/Enforce-R-Tags.alz_policy_definition.json`  | Enforces required tags on individual Resources. Excludes certain resource types (e.g., `Microsoft.Authorization/*`, `Microsoft.Insights/*`) that don't support tagging. |
| `policy_definitions/Enforce-RG-Tags.alz_policy_definition.json` | Enforces required tags on Resource Groups. Denies creation/update of resource groups missing required tags or with invalid tag values.                                  |

### Schema

```json
{
  "name": "Policy-Name",
  "type": "Microsoft.Authorization/policyDefinitions",
  "properties": {
    "policyType": "Custom",
    "mode": "All",
    "displayName": "Display Name",
    "description": "Description",
    "metadata": { "version": "1.0.0", "category": "Tags" },
    "parameters": {},
    "policyRule": {
      "if": {
        /* conditions */
      },
      "then": { "effect": "deny" }
    }
  }
}
```

## 🎯 Policy Assignments

Policy assignments link policy definitions to a specific scope such as a Management Group, this is so Azure knows exactly where a policy applies and how it should be enforced. They turn a policy definition from a standalone rule into an active governance control within your environment.

### Custom Policy Assignments

| Location                                                        | Description                                                                                                                |
| --------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------- |
| `policy_assignments/Enforce-R-Tags.alz_policy_assignment.json`  | Assigns the Resource tagging policy. Uses `Default` enforcement mode to actively deny non-compliant resources.             |
| `policy_assignments/Enforce-RG-Tags.alz_policy_assignment.json` | Assigns the Resource Group tagging policy. Uses `Default` enforcement mode to actively deny non-compliant resource groups. |

### Schema

```json
{
  "name": "Policy-Name",
  "type": "Microsoft.Authorization/policyAssignments",
  "properties": {
    "displayName": "Display Name",
    "description": "Description",
    "policyDefinitionId": "/providers/Microsoft.Management/managementGroups/placeholder/providers/Microsoft.Authorization/policyDefinitions/Policy-Name",
    "enforcementMode": "Default",
    "parameters": {}
  }
}
```

The `placeholder` value is replaced by the ALZ module with the actual root Management Group ID.

## 🧩 Archetype Definitions

Archetypes are reusable bundles that group together policy definitions, policy assignments, policy set definitions (initiatives), and role definitions. They can be assigned to Management Groups to apply a consistent set of governance controls.

### Custom Archetypes Definitions

| Location                                                         | Description                                                                             |
| ---------------------------------------------------------------- | --------------------------------------------------------------------------------------- |
| `archetype_definitions/custom_alz.alz_archetype_definition.json` | Custom archetype containing the tagging policies (`Enforce-RG-Tags`, `Enforce-R-Tags`). |

### Schema

```json
{
  "name": "archetype_name",
  "policy_assignments": ["Policy-A", "Policy-B"],
  "policy_definitions": ["Policy-A", "Policy-B"],
  "policy_set_definitions": [],
  "role_definitions": []
}
```

---

## 🏛️ Architecture Definitions

Architecture definitions define the Management Group hierarchy and map archetypes to each Management Group. They control which policies are applied at each level of the hierarchy.

### Custom Architecture Definitions

| File                                                                      | Description                                                                                                                                                                                                                                                                                                  |
| ------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `architecture_definitions/base.alz_architecture_definition.json`          | Management group hierarchy **without** any policy archetypes. Creates the structure only: `version-1` (root) → `platform`, `landing-zones`, `decommissioned`, `sandbox` → child groups under platform (`connectivity`, `identity`, `management`, `security`, `shared`). Used when `deploy_policies = false`. |
| `architecture_definitions/base-policies.alz_architecture_definition.json` | Management group hierarchy **with** CAF and custom policy archetypes. Same structure as `base`, but assigns archetypes: `root` + `custom_alz` at root level, and standard ALZ archetypes (`platform`, `landing_zones`, `connectivity`, etc.) at appropriate levels. Used when `deploy_policies = true`.      |

### Management Group Hierarchy

```
version-1 (root)
├── platform
│   ├── connectivity
│   ├── identity
│   ├── management
│   ├── security
│   └── shared
├── landing-zones
├── decommissioned
└── sandbox
```

### Schema

```json
{
  "name": "architecture-name",
  "management_groups": [
    {
      "ID": "mg-id",
      "display_name": "Management Group Name",
      "archetypes": ["root", "custom_alz"],
      "parent_id": null,
      "exists": false
    }
  ]
}
```

## 🏷️ Tagging Policy Alignment

The tagging policies define required tags and allowed values. **If modified, all dependent repositories must update their `_tags.tf` to match.**

### Required Tags

| Tag            | Allowed Values                                                       |
| -------------- | -------------------------------------------------------------------- |
| `Environment`  | `Dev`, `Test`, `UAT`, `Staging`, `PreProd`, `Prod`, `PoC`, `Sandbox` |
| `Criticality`  | `Low`, `Medium`, `High`, `Mission-Critical`                          |
| `BusinessUnit` | Any (required)                                                       |
| `Owner`        | Any (required)                                                       |
| `CostCenter`   | Any (required)                                                       |
| `Application`  | Any (required)                                                       |
| `OpsTeam`      | Any (required)                                                       |

### Modifying Tags

1. Update policy definitions in `policy_definitions/`
2. Update `_tags.tf` in **all** dependent repositories to align

### Excluded Resource Types

Resource types in the `notIn` array of `Enforce-R-Tags` are excluded from tag enforcement (e.g., `Microsoft.Authorization/*`, `Microsoft.Insights/*`, `Microsoft.Resources/deployments`).

---

## 🚀 Deployment Control

`deploy_policies` variable controls architecture selection:

- `false` → `base` architecture (no policies)
- `true` → `base-policies` architecture (with CAF policies)
