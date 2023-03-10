data "azurerm_role_definition" "sg_blob_reader" {
  name  = "Storage Blob Data Reader"
  scope = data.azurerm_subscription.scope.id
}

resource "azurerm_user_assigned_identity" "sql" {
  location            = data.azurerm_resource_group.nerdio.location
  name                = module.naming.generated_names.domain.user_assigned_identity[0]
  resource_group_name = data.azurerm_resource_group.nerdio.name
}

module "key_vault_key_sql" {
  source       = "git::https://9025-CICD@dev.azure.com/9025-CICD/ESLZ%20Modules/_git/terraform-azurerm-key-vault-key?ref=1.0.1"
  name         = module.naming.generated_names.domain.key_vault_key[0]
  key_vault_id = module.key_vault.id
  key_type     = "RSA"
  key_size     = "3072"

  key_opts = [
    "unwrapKey",
    "wrapKey",
  ]
}

module "roleassignment_sg_1" {
  source             = "git::https://9025-CICD@dev.azure.com/9025-CICD/ESLZ%20Modules/_git/terraform-azurerm-role-assignment?ref=1.0.3"
  scope              = module.storage_account_1.id
  role_definition_id = data.azurerm_role_definition.sg_blob_reader.id
  principal_id       = [local.object_id_tcg]
}

module "storage_account_1" {
  source              = "git::https://9025-CICD@dev.azure.com/9025-CICD/ESLZ%20Modules/_git/terraform-azurerm-storage-account?ref=1.0.6"
  resource_group_name = data.azurerm_resource_group.nerdio.name
  name                = module.naming.generated_names.domain.storage_account[5]
  location            = data.azurerm_resource_group.nerdio.location
  key_vault_id        = module.key_vault.id
  network_rules       = local.network_rules_2
  containers          = local.storage_containers
  cmk_enabled         = true # This parameter is not needed for real implementation
}

module "mssql_server" {
  source                              = "git::https://9025-CICD@dev.azure.com/9025-CICD/ESLZ%20Modules/_git/terraform-azurerm-mssql-server?ref=1.0.4"
  mssql_server_name                   = module.naming.generated_names.domain.sql_server[0]
  resource_group_id                   = data.azurerm_resource_group.nerdio.id
  location                            = data.azurerm_resource_group.nerdio.location
  key_vault_id                        = module.key_vault.id
  login_username                      = local.application_name
  object_id                           = local.object_id
  tenant_id                           = data.azuread_client_config.current.tenant_id
  key_vault_key_id                    = module.key_vault_key_sql.id
  storage_account_id                  = module.storage_account_1.id
  blob_endpoint                       = module.storage_account_1.primary_blob_endpoint
  user_assigned_identity_id           = azurerm_user_assigned_identity.sql.id
  user_assigned_identity_principal_id = azurerm_user_assigned_identity.sql.principal_id

  depends_on = [
    module.key_vault_key_sql
  ]

}

module "mssql-database" {
  source              = "git::https://9025-CICD@dev.azure.com/9025-CICD/ESLZ%20Modules/_git/terraform-azurerm-mssql-database?ref=1.0.4"
  mssql_database_name = module.naming.generated_names.domain.sql_database[0]
  mssql_server_id     = module.mssql_server.id
  storage_account_id  = module.storage_account_1.id
  blob_endpoint       = module.storage_account_1.primary_blob_endpoint
}


locals {
  storage_containers = {
    container1 = {
      name = module.naming.generated_names.domain.storage_container[0]
    }
  }
  network_rules_2 = {
    default_action = "Deny"
    ip_rules = [
      "203.41.142.76",
      "203.41.142.77",
      "203.35.135.168",
      "203.35.135.174",
      "203.35.185.76",
      "203.35.185.77",
      "20.53.53.224",
      "20.70.222.112",
      "104.210.230.26",
      "104.210.231.26",
      "104.209.104.3"
    ]
    virtual_network_subnet_ids = []
  }
}