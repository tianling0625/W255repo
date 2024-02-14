data "azurerm_subscription" "current" {}

resource "azuread_invitation" "invitations" {
  for_each = toset(concat(local.instructors, local.students, local.team_members))

  user_email_address = each.key
  user_display_name  = each.key
  redirect_url       = "https://portal.azure.com"

  message {
    additional_recipients = ["winegarj@berkeley.edu"]
    body                  = "You are formally invited to W255's Azure AD tenant where we will manage all access"
  }
}

data "azuread_users" "users" {
  return_all = true
  depends_on = [
    azuread_invitation.invitations
  ]
}

resource "azurerm_role_assignment" "instructors" {
  for_each = toset(local.instructors)
  depends_on = [
    azuread_invitation.invitations
  ]

  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Contributor"
  principal_id         = [for x in data.azuread_users.users.users : x.object_id if x.mail == each.key][0]
}

resource "azurerm_role_assignment" "students" {
  for_each = toset(concat(local.students, local.team_members))
  depends_on = [
    azuread_invitation.invitations
  ]

  scope                = azurerm_resource_group.rg.id
  role_definition_name = "Reader"
  principal_id         = [for x in data.azuread_users.users.users : x.object_id if x.mail == each.key][0]
}

resource "azurerm_role_assignment" "students_aks" {
  for_each = toset(concat(local.students, local.team_members))
  depends_on = [
    azuread_invitation.invitations
  ]

  scope                = azurerm_kubernetes_cluster.k8s.id
  role_definition_name = "Azure Kubernetes Service Cluster User Role"
  principal_id         = [for x in data.azuread_users.users.users : x.object_id if x.mail == each.key][0]
}

resource "azurerm_role_assignment" "students_acr" {
  for_each = toset(concat(local.students, local.team_members))
  depends_on = [
    azuread_invitation.invitations
  ]

  scope                = azurerm_container_registry.acr.id
  role_definition_name = "AcrPush"
  principal_id         = [for x in data.azuread_users.users.users : x.object_id if x.mail == each.key][0]
}

resource "random_uuid" "aks_namespace" {}

resource "azurerm_role_definition" "aks_namespace" {
  name               = "AKS Portal Viewer"
  scope              = data.azurerm_subscription.current.id
  role_definition_id = random_uuid.aks_namespace.result
  description        = "Custom Role to view AKS resoures (namespaces, services, etc.) in Azure Portal"

  permissions {
    data_actions = [
      "Microsoft.ContainerService/managedClusters/*/read"
    ]
    not_data_actions = []
  }

  assignable_scopes = [
    data.azurerm_subscription.current.id,
  ]
}


resource "azurerm_role_assignment" "namespace_portal_view" {
  for_each = toset(concat(local.instructors, local.students, local.team_members))
  depends_on = [
    azuread_invitation.invitations,
    azurerm_role_definition.aks_namespace
  ]

  scope                = azurerm_kubernetes_cluster.k8s.id
  role_definition_name = azurerm_role_definition.aks_namespace.name
  principal_id         = [for x in data.azuread_users.users.users : x.object_id if x.mail == each.key][0]
}
