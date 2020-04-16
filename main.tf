provider "azurerm" {
  version = "=2.0.0"
  
  subscription_id = var.subscription_id
  client_id = var.client_id
  client_secret = var.client_secret
  tenant_id = var.tenant_id

  features {}
}

resource "azurerm_resource_group" "htu_tf_devtest" {
  name     = "htu_tf_devtest"
  location = var.location
}

# shared image gallery
resource "azurerm_shared_image_gallery" "htu_tf_SIG" {
  name                = "htu_tf_SIG"
  resource_group_name = azurerm_resource_group.htu_tf_devtest.name
  location            = azurerm_resource_group.htu_tf_devtest.location
  description         = "Shared images and things."

  tags = {
  }
}

resource "azurerm_shared_image" "htu_tf_image" {
  name                = "packer_tf"
  gallery_name        = azurerm_shared_image_gallery.htu_tf_SIG.name
  resource_group_name = azurerm_resource_group.htu_tf_devtest.name
  location            = azurerm_resource_group.htu_tf_devtest.location
  os_type             = "Linux"

  identifier {
    publisher = "htu"
    offer     = "packer_images"
    sku       = "RHEL_nginx"
  }
}

# devtest lab
resource "azurerm_dev_test_lab" "htu_tf_devtestlab" {
  name                = "htu_tf_devtestlab"
  location            = azurerm_resource_group.htu_tf_devtest.location
  resource_group_name = azurerm_resource_group.htu_tf_devtest.name

  tags = {
    "env" = "test"
  }
}