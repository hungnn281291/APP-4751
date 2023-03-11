module "application_insights" {
  source                   = "git::https://github.com/hungnn281291/Modules.git//terraform-azurerm-application-insights"
  application_insight_name = module.naming.generated_names.domain.application_insights[0]
  resource_group_name      = data.azurerm_resource_group.nerdio.name
  location                 = data.azurerm_resource_group.nerdio.location
  application_type         = "web"
}
