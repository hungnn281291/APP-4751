module "SharedImageGallery" {
  source                    = "git::https://github.com/hungnn281291/Modules.git//terraform-azurerm-shared-image-gallery"
  resource_group_name       = data.azurerm_resource_group.nerdio.name
  location                  = data.azurerm_resource_group.nerdio.location
  description               = "AVD Compute Gallery"
  shared_image_gallery_name = module.naming.generated_names.domain.azure_compute_gallery[0]
}