module "azurerm_windows_web_app" {
  source                                       = "git::https://9025-CICD@dev.azure.com/9025-CICD/ESLZ%20Modules/_git/terraform-azurerm-windows-app-service?ref=1.0.5"
  resource_group_name                          = data.azurerm_resource_group.nerdio.name
  location                                     = data.azurerm_resource_group.nerdio.location
  app_service_plan_name                        = module.naming.generated_names.domain.app_service_plan[0]
  app_service_name                             = module.naming.generated_names.domain.app_service[0]
  os_type                                      = local.app_os_type
  sku_name                                     = local.app_sku_name
  ftps_state                                   = local.app_ftps_state
  app_ip_restriction_virtual_network_subnet_id = data.azurerm_subnet.snet001.id
  scm_ip_restriction_virtual_network_subnet_id = data.azurerm_subnet.snet001.id
  app_ip_restriction_service_tag               = ""
  enabled                                      = "false" #disabling auth_settings as Nerdio will handle authentication
  allowed_origins                              = ["mysite"]
  virtual_network_subnet_id                    = data.azurerm_subnet.snet001.id
  use_32_bit_worker                            = false
  app_settings = {
    "APPLICATIONINSIGHTS_CONNECTION_STRING" = module.application_insights.connection_string
    "APPINSIGHTS_INSTRUMENTATIONKEY"        = module.application_insights.instrumentation_key
    "AzureAd:Instance"                      = "https://login.microsoftonline.com/"
    "AzureAd:ClientId"                      = local.application_id
    "AzureAd:TenantId"                      = local.tenant_id
    "Billing:Mode"                          = "MAU"
    #"ConnectionStrings--DefaultConnection"  = module.key_vault_secret_2.value
    #"Deployment:AutomationAccountName"   = module.automation_account.name
    "Deployment:AutomationEnabled"       = "True"
    "Deployment:AzureTagPrefix"          = "NMW"
    "Deployment:AzureType"               = "AzureCloud"
    "Deployment:KeyVaultName"            = module.naming.generated_names.domain.key_vault[1]
    "Deployment:LogAnalyticsWorkspace"   = module.naming.generated_names.domain.log_analytics_workspace[0]
    "Deployment:Region"                  = data.azurerm_resource_group.nerdio.location
    "Deployment:ResourceGroupName"       = data.azurerm_resource_group.nerdio.name
    "Deployment:ScriptedActionAccount"   = module.naming.generated_names.domain.automation_account[0]
    "Deployment:SubscriptionId"          = local.app_sub_id
    "Deployment:SubscriptionDisplayName" = local.app_sub_name
    "Deployment:TenantId"                = local.tenant_id
    "Deployment:UpdaterRunbookRunAs"     = "nmwUpdateRunAs"
    "Deployment:WebAppName"              = module.naming.generated_names.domain.app_service[0]
    "RoleAuthorization:Enabled"          = "True"
    "WVD:AadTenantId"                    = local.tenant_id
    "WVD:SubscriptionId"                 = local.app_sub_id
  }
}

module "log_analytics_workspace" {
  source                     = "git::https://9025-CICD@dev.azure.com/9025-CICD/ESLZ%20Modules/_git/terraform-azurerm-log-analytics-workspace?ref=1.0.2"
  name                       = module.naming.generated_names.domain.log_analytics_workspace[0]
  location                   = data.azurerm_resource_group.nerdio.location
  resource_group_name        = data.azurerm_resource_group.nerdio.name
  sku                        = "PerGB2018"
  retention_in_days          = 31
  internet_ingestion_enabled = true
  internet_query_enabled     = true
}

module "diagnostics_log" {
  source                     = "git::https://9025-CICD@dev.azure.com/9025-CICD/ESLZ%20Modules/_git/terraform-azurerm-diagnostic-logs?ref=1.0.3"
  name                       = "appservicediags"
  target_resource_id         = module.azurerm_windows_web_app.app_service_id
  log_analytics_workspace_id = module.log_analytics_workspace.id
}
