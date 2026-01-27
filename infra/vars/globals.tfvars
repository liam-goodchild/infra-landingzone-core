#########################################
# Generic
#########################################
project = "sh"

#########################################
# RBAC
#########################################
rbac_groups = [
  {
    name                = "Owner"
    group_members_names = []
    role_definitions = [
      "Owner"
    ]
  },
  {
    name                = "Contributor"
    group_members_names = []
    role_definitions = [
      "Contributor"
    ]
  },
  {
    name                = "Reader"
    group_members_names = []
    role_definitions = [
      "Reader"
    ]
  }
]

#########################################
# CAF Policy deployment
#########################################
deploy_caf_policies = false
