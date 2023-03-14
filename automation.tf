resource "azurerm_user_assigned_identity" "automation" {
  location            = data.azurerm_resource_group.nerdio.location
  name                = module.naming.generated_names.domain.user_assigned_identity[1]
  resource_group_name = data.azurerm_resource_group.nerdio.name
}


module "key_vault_key_automation" {
  source       = "git::https://github.com/hungnn281291/Modules.git//terraform-azurerm-key-vault-key"
  name         = module.naming.generated_names.domain.key_vault_key[1]
  key_vault_id = module.key_vault.id
  key_type     = "RSA"
  key_size     = "3072"
  key_opts     = ["decrypt", "encrypt", "sign", "unwrapKey", "verify", "wrapKey"]
  depends_on = [
    module.key_vault
  ]
}

module "automation_account" {
  source                              = "git::https://github.com/hungnn281291/Modules.git//terraform-azurerm-automation-account"
  resource_group_name                 = data.azurerm_resource_group.nerdio.name
  azurerm_automation_account_name     = module.naming.generated_names.domain.automation_account[0]
  location                            = data.azurerm_resource_group.nerdio.location
  key_vault_id                        = module.key_vault.id
  key_vault_key_id                    = module.key_vault_key_automation.id
  user_assigned_identity_id           = azurerm_user_assigned_identity.automation.id
  user_assigned_identity_principal_id = azurerm_user_assigned_identity.automation.principal_id
}
