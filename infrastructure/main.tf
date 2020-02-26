/***************************************************************************
* File Name: main.tf
* Author: Chun Wu
* Email: the.chun.wu@gmail.com
* Date: 02/25/2020
*
* Purpose: IaaS code to provision infrastructure for static site.
*
***************************************************************************/

resource "azurerm_resource_group" "chunwu-dev-rg" {
    name                    = var.RESOURCE_GROUP_NAME
    location                = var.AZURE_REGION
}

resource "azurerm_storage_account" "chunwu-dev-sa" {
  name                     = "chunwudevsa"
  resource_group_name      = azurerm_resource_group.chunwu-dev-rg.name
  location                 = azurerm_resource_group.chunwu-dev-rg.location
  account_kind             = "StorageV2"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "chunwu-dev-sc" {
  name                  = "chunwudevsc"
  resource_group_name   = azurerm_resource_group.chunwu-dev-rg.name
  storage_account_name  = azurerm_storage_account.chunwu-dev-sa.name
  container_access_type = "private"
}