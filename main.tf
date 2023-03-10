locals {
  env_specific_config     = jsondecode(file("${path.root}/config/${var.env_specific_config}")).input_parameters
  app_sub_id              = local.env_specific_config.app_sub_id
  app_sub_name            = local.env_specific_config.app_sub_name
  app_short_name          = local.env_specific_config.app_short_name
  app_sku_name            = local.env_specific_config.app_sku_name
  app_os_type             = local.env_specific_config.app_os_type
  app_ftps_state          = local.env_specific_config.app_ftps_state
  app_allowed_origins     = local.env_specific_config.app_allowed_origins
  environment             = local.env_specific_config.environment
  location                = local.env_specific_config.location
  tenant_id               = local.env_specific_config.tenant_id
  resource_group_name     = local.env_specific_config.resource_group_name
  resource_group_name_2   = local.env_specific_config.resource_group_name_2
  resource_group_name_3   = local.env_specific_config.resource_group_name_3
  virtual_network_name    = local.env_specific_config.virtual_network_name
  virtual_network_name_rg = local.env_specific_config.virtual_network_name_rg
  subnet_01               = local.env_specific_config.subnet_01
  subnet_02               = local.env_specific_config.subnet_02
  network_rules           = local.env_specific_config.network_rules
  private_dns_zones_rg    = local.env_specific_config.private_dns_zones_rg
  application_name        = local.env_specific_config.application_name
  application_id          = local.env_specific_config.application_id
  object_id               = local.env_specific_config.object_id
  object_id_tcg           = local.env_specific_config.object_id_tcg
  environment_location_id = local.env_specific_config.environment_location_id
  tags                    = local.env_specific_config.tags
}

module "naming" {
  source       = "git::https://9025-CICD@dev.azure.com/9025-CICD/ESLZ%20Modules/_git/terraform-azurerm-naming?ref=1.0.7"
  product_area = "tcg"
  environment  = local.environment
  location     = local.location
  domain       = local.app_short_name
  generator = {
    domain = {
      random                  = 1
      app_service             = 2
      app_service_plan        = 1
      application_insights    = 1
      log_analytics_workspace = 1
      key_vault               = 2
      key_vault_key           = 2
      sql_server              = 1
      sql_database            = 1
      automation_account      = 1
      azure_compute_gallery   = 1
      private_endpoint        = 9
      network_interface       = 9
      storage_account         = 6
      storage_blob            = 4
      storage_container       = 4
      user_assigned_identity  = 2
    }
  }
}

data "azuread_client_config" "current" {}

data "azurerm_resource_group" "nerdio" {
  name = local.resource_group_name
}

data "azurerm_resource_group" "nerdio2" {
  name = local.resource_group_name_2
}

data "azurerm_resource_group" "nerdio3" {
  name = local.resource_group_name_3
}

data "azurerm_virtual_network" "nerdio" {
  name                = local.virtual_network_name
  resource_group_name = local.virtual_network_name_rg
}

data "azurerm_subnet" "snet001" {
  name                 = local.subnet_01
  virtual_network_name = data.azurerm_virtual_network.nerdio.name
  resource_group_name  = data.azurerm_virtual_network.nerdio.resource_group_name
}

data "azurerm_subnet" "endpoints" {
  name                 = local.subnet_02
  virtual_network_name = data.azurerm_virtual_network.nerdio.name
  resource_group_name  = data.azurerm_virtual_network.nerdio.resource_group_name
}

data "azurerm_private_dns_zone" "web" {
  provider            = azurerm.secondary
  name                = "privatelink.azurewebsites.net"
  resource_group_name = local.private_dns_zones_rg
}

data "azurerm_private_dns_zone" "blob" {
  provider            = azurerm.secondary
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = local.private_dns_zones_rg
}

data "azurerm_private_dns_zone" "database" {
  provider            = azurerm.secondary
  name                = "privatelink.database.windows.net"
  resource_group_name = local.private_dns_zones_rg
}

data "azurerm_private_dns_zone" "file" {
  provider            = azurerm.secondary
  name                = "privatelink.file.core.windows.net"
  resource_group_name = local.private_dns_zones_rg
}

data "azurerm_private_dns_zone" "vault" {
  provider            = azurerm.secondary
  name                = "privatelink.vaultcore.azure.net"
  resource_group_name = local.private_dns_zones_rg
}

/*
data "azurerm_mssql_server" "sql" {
  name                = module.naming.generated_names.domain.storage_account[0]
  resource_group_name = data.azurerm_resource_group.nerdio.name

  depends_on = [
    module.mssql_server
  ]
}

data "azurerm_windows_web_app" "webapp" {
  name = module.naming.generated_names.domain.app_service[0]
  resource_group_name = data.azurerm_resource_group.nerdio.name

  depends_on = [
    module.azurerm_windows_web_app
  ]
}

data "azurerm_user_assigned_identity" "automation" {
  
  resource_group_name = data.azurerm_resource_group.nerdio.name
  name                = module.naming.generated_names.domain.user_assigned_identity[1]

}*/