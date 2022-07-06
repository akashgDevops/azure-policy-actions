resource "azurerm_policy_definition" "auditRoleAssignmentType_user" {
  name         = "auditRoleAssignmentType_user"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "AG:Audit user role assignments"
  description  = "This policy checks for any Role Assignments of Type [User] - useful to catch individual IAM assignments to resources/RGs which are out of compliance with the RBAC standards e.g. using Groups for RBAC."

  metadata = jsonencode(
    {
      "category" : "${var.policy_definition_category}",
      "version" : "1.0.0"
    }
  )
  policy_rule = jsonencode(
    {
      "if" : {
        "allOf" : [
          {
            "field" : "type",
            "equals" : "Microsoft.Authorization/roleAssignments"
          },
          {
            "field" : "Microsoft.Authorization/roleAssignments/principalType",
            "equals" : "[parameters('principalType')]"
          }
        ]
      },
      "then" : {
        "effect" : "audit"
      }
    }
  )
  parameters = jsonencode(
    {
      "principalType" : {
        "type" : "String",
        "metadata" : {
          "displayName" : "principalType",
          "description" : "Which principalType to audit against e.g. 'User'"
        },
        "allowedValues" : [
          "User",
          "Group",
          "ServicePrincipal"
        ],
        "defaultValue" : "User"
      }
    }
  )
}

resource "azurerm_subscription_policy_assignment" "audituserrole" { 
 name = "audit-userrole" 
 subscription_id = var.cust_scope 
 policy_definition_id = azurerm_policy_definition.auditRoleAssignmentType_user.id
 description = "AG:Audit user role assignments" 
 display_name = "AG:Audit user role assignments" 
}
