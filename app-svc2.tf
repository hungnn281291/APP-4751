resource "azurerm_windows_web_app" "nerdio" {
  name                       = module.naming.generated_names.domain.app_service[1]
  resource_group_name        = data.azurerm_resource_group.nerdio.name
  location                   = data.azurerm_resource_group.nerdio.location
  service_plan_id            = module.azurerm_windows_web_app.Plan_id
  https_only                 = true
  client_affinity_enabled    = var.client_affinity_enabled
  client_certificate_enabled = true       #AAS_ENC_005
  client_certificate_mode    = "Required" #AAS_ENC_005
  virtual_network_subnet_id  = data.azurerm_subnet.snet001.id

  site_config {
    always_on                = true
    api_management_api_id    = var.api_management_api_id
    app_command_line         = var.app_command_line
    http2_enabled            = true
    websockets_enabled       = var.websockets_enabled #AAS_TDS_009
    health_check_path        = var.health_check_path
    minimum_tls_version      = 1.2
    ftps_state               = "Disabled"
    use_32_bit_worker        = false
    scm_minimum_tls_version  = 1.2   #AAS_ENC_004
    vnet_route_all_enabled   = true  #AAS_NET_002
    remote_debugging_enabled = false #AAS_TDS_008

    dynamic "cors" {
      for_each = var.cors_rule_enabled == true ? [1] : []
      content {
        allowed_origins     = ["mysite"]
        support_credentials = var.support_credentials
      }
    }

    application_stack {
      current_stack  = "dotnet"
      dotnet_version = "v6.0"
    }
  }

  app_settings = {
    //"ApplicationInsights:ConnectionString"   = azurerm_application_insights.nerdio.connection_string
    //"ApplicationInsights:InstrumentationKey" = azurerm_application_insights.nerdio.instrumentation_key
    "APPLICATIONINSIGHTS_CONNECTION_STRING" = module.application_insights.connection_string
    "APPINSIGHTS_INSTRUMENTATIONKEY"        = module.application_insights.instrumentation_key
    "AzureAd:Instance"                      = "https://login.microsoftonline.com/"
    "AzureAd:ClientId"                      = local.application_id
    "AzureAd:TenantId"                      = local.tenant_id
    "Billing:Mode"                          = "MAU"
    //"ConnectionStrings--DefaultConnection"  = azurerm_key_vault_secret.sql_connection.value
    #"Deployment:AutomationAccountName"   = azurerm_automation_account.nerdio.name
    "Deployment:AutomationEnabled"     = "True"
    "Deployment:AzureTagPrefix"        = "NMW"
    "Deployment:AzureType"             = "AzureCloud"
    "Deployment:KeyVaultName"          = module.naming.generated_names.domain.key_vault[1]
    "Deployment:LogAnalyticsWorkspace" = module.naming.generated_names.domain.log_analytics_workspace[0]
    "Deployment:Region"                = data.azurerm_resource_group.nerdio.location
    "Deployment:ResourceGroupName"     = data.azurerm_resource_group.nerdio.name
    #"Deployment:ScriptedActionAccount"   = azurerm_automation_account.nerdio.id
    "Deployment:SubscriptionId"          = local.app_sub_id
    "Deployment:SubscriptionDisplayName" = local.app_sub_name
    "Deployment:TenantId"                = local.tenant_id
    "Deployment:UpdaterRunbookRunAs"     = "nmwUpdateRunAs"
    "Deployment:WebAppName"              = module.naming.generated_names.domain.app_service[1]
    "RoleAuthorization:Enabled"          = "True"
    "WVD:AadTenantId"                    = local.tenant_id
    "WVD:SubscriptionId"                 = local.app_sub_id
  }

  identity {
    type = "SystemAssigned"
  }

  tags = local.tags
}

variable "cors_rule_enabled" {
  type        = bool
  description = "Is cors rule enabled?"
  default     = false
}

variable "support_credentials" {
  type        = bool
  description = "Whether CORS requests with credentials are allowed.Only needed when cors_rule_enabled is `true`"
  default     = false
}

variable "app_ip_restriction_ip_address" {
  type        = string
  description = "The CIDR notation of the IP or IP Range to match. For example: 192.0.0.0/24 or 192.168.10.10/32.One and only one of app_ip_restriction_ip_address, app_ip_restriction_service_tag or app_ip_restriction_virtual_network_subnet_id must be specified."
  default     = ""
}

variable "app_ip_restriction_service_tag" {
  type        = string
  description = "The Service Tag used for app IP Restriction.One and only one of app_ip_restriction_ip_address, app_ip_restriction_service_tag or app_ip_restriction_virtual_network_subnet_id must be specified."
  default     = ""
}

variable "client_affinity_enabled" {
  type        = bool
  description = "Should Client Affinity be enabled?"
  default     = false
}

variable "api_management_api_id" {
  type        = any
  description = "The API Management API ID this Windows Web App Slot is associated with."
  default     = null
}

variable "app_command_line" {
  type        = any
  description = "The App command line to launch."
  default     = null
}

variable "websockets_enabled" {
  type        = bool
  description = "Should Web Sockets be enabled. Defaults to false"
  default     = false #AAS_TDS_009
}

variable "health_check_path" {
  type        = string
  description = "The path to the Health Check."
  default     = null
}