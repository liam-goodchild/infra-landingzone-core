#########################################
# Generic
#########################################
environment = "prd"
location    = "uksouth"

tags = {
  Environment = "prd"
}

#########################################
# Subscription Placement (add mappings as needed)
#########################################
management_group_subscriptions = [
  {
    id               = "landing-zones"
    subscription_ids = ["48a8b708-dc42-468f-97bc-fd949c073eb8"]
  }
]
