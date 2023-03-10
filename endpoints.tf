module "private_endpoint_1" {
  source                        = "git::https://9025-CICD@dev.azure.com/9025-CICD/ESLZ%20Modules/_git/terraform-azurerm-private-endpoint?ref=1.0.1"
  location                      = data.azurerm_resource_group.nerdio.location
  resource_group_name           = data.azurerm_resource_group.nerdio.name
  privateendpoint_name          = module.naming.generated_names.domain.private_endpoint[0]
  subnet_id                     = data.azurerm_subnet.endpoints.id
  custom_network_interface_name = module.naming.generated_names.domain.network_interface[0]
  #ipconfiguration_name           = var.ipconfiguration_name
  #private_ip_address             = var.private_ip_address
  subresource_name               = "vault"
  private_dns_zone_group_name    = "default"
  private_dns_zone_ids           = [data.azurerm_private_dns_zone.vault.id]
  private_connection_resource_id = module.key_vault.id
  subresource_names              = ["vault"]
}

module "private_endpoint_2" {
  source                        = "git::https://9025-CICD@dev.azure.com/9025-CICD/ESLZ%20Modules/_git/terraform-azurerm-private-endpoint?ref=1.0.1"
  location                      = data.azurerm_resource_group.nerdio.location
  resource_group_name           = data.azurerm_resource_group.nerdio.name
  privateendpoint_name          = module.naming.generated_names.domain.private_endpoint[1]
  subnet_id                     = data.azurerm_subnet.endpoints.id
  custom_network_interface_name = module.naming.generated_names.domain.network_interface[1]
  #ipconfiguration_name           = var.ipconfiguration_name
  #private_ip_address             = var.private_ip_address
  subresource_name               = "sqlServer"
  private_dns_zone_group_name    = "default"
  private_dns_zone_ids           = [data.azurerm_private_dns_zone.database.id]
  private_connection_resource_id = module.mssql_server.id
  subresource_names              = ["sqlServer"]
}

module "private_endpoint_3" {
  source                        = "git::https://9025-CICD@dev.azure.com/9025-CICD/ESLZ%20Modules/_git/terraform-azurerm-private-endpoint?ref=1.0.1"
  location                      = data.azurerm_resource_group.nerdio.location
  resource_group_name           = data.azurerm_resource_group.nerdio.name
  privateendpoint_name          = module.naming.generated_names.domain.private_endpoint[3]
  subnet_id                     = data.azurerm_subnet.endpoints.id
  custom_network_interface_name = module.naming.generated_names.domain.network_interface[3]
  #ipconfiguration_name           = var.ipconfiguration_name
  #private_ip_address             = var.private_ip_address
  subresource_name               = "sites"
  private_dns_zone_group_name    = "default"
  private_dns_zone_ids           = [data.azurerm_private_dns_zone.web.id]
  private_connection_resource_id = module.azurerm_windows_web_app.app_service_id
  subresource_names              = ["sites"]
}

module "private_endpoint_4" {
  source                        = "git::https://9025-CICD@dev.azure.com/9025-CICD/ESLZ%20Modules/_git/terraform-azurerm-private-endpoint?ref=1.0.1"
  location                      = data.azurerm_resource_group.nerdio.location
  resource_group_name           = data.azurerm_resource_group.nerdio.name
  privateendpoint_name          = module.naming.generated_names.domain.private_endpoint[4]
  subnet_id                     = data.azurerm_subnet.endpoints.id
  custom_network_interface_name = module.naming.generated_names.domain.network_interface[4]
  #ipconfiguration_name           = var.ipconfiguration_name
  #private_ip_address             = var.private_ip_address
  subresource_name               = "blob"
  private_dns_zone_group_name    = "default"
  private_dns_zone_ids           = [data.azurerm_private_dns_zone.blob.id]
  private_connection_resource_id = module.storage_account_1.id
  subresource_names              = ["blob"]
}

module "private_endpoint_5" {
  source                        = "git::https://9025-CICD@dev.azure.com/9025-CICD/ESLZ%20Modules/_git/terraform-azurerm-private-endpoint?ref=1.0.1"
  location                      = data.azurerm_resource_group.nerdio.location
  resource_group_name           = data.azurerm_resource_group.nerdio.name
  privateendpoint_name          = module.naming.generated_names.domain.private_endpoint[5]
  subnet_id                     = data.azurerm_subnet.endpoints.id
  custom_network_interface_name = module.naming.generated_names.domain.network_interface[5]
  #ipconfiguration_name           = var.ipconfiguration_name
  #private_ip_address             = var.private_ip_address
  subresource_name               = "blob"
  private_dns_zone_group_name    = "default"
  private_dns_zone_ids           = [data.azurerm_private_dns_zone.blob.id]
  private_connection_resource_id = module.storage_account_2.id
  subresource_names              = ["blob"]
}

module "private_endpoint_6" {
  source                        = "git::https://9025-CICD@dev.azure.com/9025-CICD/ESLZ%20Modules/_git/terraform-azurerm-private-endpoint?ref=1.0.1"
  location                      = data.azurerm_resource_group.nerdio.location
  resource_group_name           = data.azurerm_resource_group.nerdio.name
  privateendpoint_name          = module.naming.generated_names.domain.private_endpoint[6]
  subnet_id                     = data.azurerm_subnet.endpoints.id
  custom_network_interface_name = module.naming.generated_names.domain.network_interface[6]
  #ipconfiguration_name           = var.ipconfiguration_name
  #private_ip_address             = var.private_ip_address
  subresource_name               = "blob"
  private_dns_zone_group_name    = "default"
  private_dns_zone_ids           = [data.azurerm_private_dns_zone.blob.id]
  private_connection_resource_id = module.storage_account_3.id
  subresource_names              = ["blob"]
}

module "private_endpoint_7" {
  source                        = "git::https://9025-CICD@dev.azure.com/9025-CICD/ESLZ%20Modules/_git/terraform-azurerm-private-endpoint?ref=1.0.1"
  location                      = data.azurerm_resource_group.nerdio.location
  resource_group_name           = data.azurerm_resource_group.nerdio.name
  privateendpoint_name          = module.naming.generated_names.domain.private_endpoint[7]
  subnet_id                     = data.azurerm_subnet.endpoints.id
  custom_network_interface_name = module.naming.generated_names.domain.network_interface[7]
  #ipconfiguration_name           = var.ipconfiguration_name
  #private_ip_address             = var.private_ip_address
  subresource_name               = "blob"
  private_dns_zone_group_name    = "default"
  private_dns_zone_ids           = [data.azurerm_private_dns_zone.blob.id]
  private_connection_resource_id = module.storage_account_4.id
  subresource_names              = ["blob"]
}

module "private_endpoint_8" {
  source                        = "git::https://9025-CICD@dev.azure.com/9025-CICD/ESLZ%20Modules/_git/terraform-azurerm-private-endpoint?ref=1.0.1"
  location                      = data.azurerm_resource_group.nerdio.location
  resource_group_name           = data.azurerm_resource_group.nerdio.name
  privateendpoint_name          = module.naming.generated_names.domain.private_endpoint[8]
  subnet_id                     = data.azurerm_subnet.endpoints.id
  custom_network_interface_name = module.naming.generated_names.domain.network_interface[8]
  #ipconfiguration_name           = var.ipconfiguration_name
  #private_ip_address             = var.private_ip_address
  subresource_name               = "sites"
  private_dns_zone_group_name    = "default"
  private_dns_zone_ids           = [data.azurerm_private_dns_zone.web.id]
  private_connection_resource_id = azurerm_windows_web_app.nerdio.id
  subresource_names              = ["sites"]
}