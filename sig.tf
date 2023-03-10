module "SharedImageGallery" {
  source                    = "git::https://9025-CICD@dev.azure.com/9025-CICD/ESLZ%20Modules/_git/terraform-azurerm-shared-image-gallery?ref=1.0.2"
  resource_group_name       = data.azurerm_resource_group.nerdio.name
  location                  = data.azurerm_resource_group.nerdio.location
  description               = "AVD Compute Gallery"
  shared_image_gallery_name = module.naming.generated_names.domain.azure_compute_gallery[0]
}