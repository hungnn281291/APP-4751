module "storage_account_2" {
  source              = "git::https://github.com/hungnn281291/Modules.git//terraform-azurerm-storage-account"
  resource_group_name = data.azurerm_resource_group.nerdio.name
  name                = "stn${module.naming.generated_names.domain.storage_account[1]}"
  location            = data.azurerm_resource_group.nerdio.location
  key_vault_id        = module.key_vault.id
  network_rules       = local.network_rules
  #containers          = local.storage_containers
  cmk_enabled = true # This parameter is not needed for real implementation
}

module "storage_account_3" {
  source              = "git::https://github.com/hungnn281291/Modules.git//terraform-azurerm-storage-account"
  resource_group_name = data.azurerm_resource_group.nerdio2.name
  name                = "stn${module.naming.generated_names.domain.storage_account[2]}"
  location            = data.azurerm_resource_group.nerdio.location
  key_vault_id        = module.key_vault.id
  network_rules       = local.network_rules
  #containers          = local.storage_containers
  cmk_enabled = true # This parameter is not needed for real implementation
}

module "storage_account_4" {
  source              = "git::https://github.com/hungnn281291/Modules.git//terraform-azurerm-storage-account"
  resource_group_name = data.azurerm_resource_group.nerdio3.name
  name                = "stn${module.naming.generated_names.domain.storage_account[3]}"
  location            = data.azurerm_resource_group.nerdio.location
  key_vault_id        = module.key_vault.id
  network_rules       = local.network_rules
  #containers          = local.storage_containers
  cmk_enabled = true # This parameter is not needed for real implementation
}
