data "azurerm_subscription" "scope" {}
data "azurerm_role_definition" "key_vault_role_1" {
  name  = "Key Vault Administrator"
  scope = data.azurerm_subscription.scope.id
}
data "azurerm_role_definition" "key_vault_role_2" {
  name  = "Key Vault Crypto User"
  scope = data.azurerm_subscription.scope.id
}
data "azurerm_role_definition" "key_vault_role_3" {
  name  = "Key Vault Secrets Officer"
  scope = data.azurerm_subscription.scope.id
}
data "azurerm_role_definition" "key_vault_role_4" {
  name  = "Key Vault Secrets User"
  scope = data.azurerm_subscription.scope.id
}

module "key_vault" {
  source                 = "git::https://9025-CICD@dev.azure.com/9025-CICD/ESLZ%20Modules/_git/terraform-azurerm-key-vault?ref=1.0.5"
  resource_group_name    = data.azurerm_resource_group.nerdio.name
  azurerm_key_vault_name = module.naming.generated_names.domain.key_vault[1]
  location               = data.azurerm_resource_group.nerdio.location
  tenant_id              = data.azuread_client_config.current.tenant_id
  #object_id                = data.azuread_client_config.current.object_id
  purge_protection_enabled = true
  ip_rules                 = local.network_rules
  tags                     = local.tags
}

module "roleassignment_2" {
  source             = "git::https://9025-CICD@dev.azure.com/9025-CICD/ESLZ%20Modules/_git/terraform-azurerm-role-assignment?ref=1.0.3"
  scope              = module.key_vault.id
  role_definition_id = data.azurerm_role_definition.key_vault_role_2.id
  principal_id       = [local.object_id]
}

module "roleassignment_3" {
  source             = "git::https://9025-CICD@dev.azure.com/9025-CICD/ESLZ%20Modules/_git/terraform-azurerm-role-assignment?ref=1.0.3"
  scope              = module.key_vault.id
  role_definition_id = data.azurerm_role_definition.key_vault_role_3.id
  principal_id       = [module.azurerm_windows_web_app.app_service_principal_id]

}

module "roleassignment_4" {
  source             = "git::https://9025-CICD@dev.azure.com/9025-CICD/ESLZ%20Modules/_git/terraform-azurerm-role-assignment?ref=1.0.3"
  scope              = module.key_vault.id
  role_definition_id = data.azurerm_role_definition.key_vault_role_4.id
  principal_id       = [local.object_id]
}

module "roleassignment_5" {
  source             = "git::https://9025-CICD@dev.azure.com/9025-CICD/ESLZ%20Modules/_git/terraform-azurerm-role-assignment?ref=1.0.3"
  scope              = module.key_vault.id
  role_definition_id = data.azurerm_role_definition.key_vault_role_1.id
  principal_id       = [local.object_id_tcg]
}

module "roleassignment_6" {
  source             = "git::https://9025-CICD@dev.azure.com/9025-CICD/ESLZ%20Modules/_git/terraform-azurerm-role-assignment?ref=1.0.3"
  scope              = module.key_vault.id
  role_definition_id = data.azurerm_role_definition.key_vault_role_3.id
  principal_id       = [azurerm_windows_web_app.nerdio.identity[0].principal_id]
}

module "key_vault_secret_1" {
  source       = "git::https://9025-CICD@dev.azure.com/9025-CICD/ESLZ%20Modules/_git/terraform-azurerm-key-vault-secret?ref=1.0.2"
  name         = "AzureAD--ClientSecret"
  value        = "Not Managed Here"
  key_vault_id = module.key_vault.id
  depends_on = [
    module.key_vault.id
  ]
}

module "key_vault_secret_2" {
  source = "git::https://9025-CICD@dev.azure.com/9025-CICD/ESLZ%20Modules/_git/terraform-azurerm-key-vault-secret?ref=1.0.2"
  name   = "ConnectionStrings--DefaultConnection"
  value = join(";", [
    "Server=tcp:${module.mssql_server.fully_qualified_domain_name},1433",
    //"Database=${azurerm_mssql_database.nerdio.name}",
    "Initial Catalog=${module.naming.generated_names.domain.sql_database[0]}",
    "Persist Security Info=False",
    "User ID=${local.application_id}",
    "MultipleActiveResultSets=False",
    "Encrypt=True",
    "TrustServerCertificate=False",
    "Connection Timeout=30",
    "" # Ensure the connection string ends with a semi-colon.
  ])
  key_vault_id = module.key_vault.id
  depends_on = [
    module.key_vault
  ]
}