module "application_insights" {
  source                   = "git::https://9025-CICD@dev.azure.com/9025-CICD/ESLZ%20Modules/_git/terraform-azurerm-application-insights?ref=1.0.1"
  application_insight_name = module.naming.generated_names.domain.application_insights[0]
  resource_group_name      = data.azurerm_resource_group.nerdio.name
  location                 = data.azurerm_resource_group.nerdio.location
  application_type         = "web"
}