/***************************************************************************
* File Name: provider.tf
* Author: Chun Wu
* Email: the.chun.wu@gmail.com
* Date: 02/25/2020
*
* Purpose: Configures the credentials for Azure
*
***************************************************************************/

provider "azurerm" {
    version                 = "1.44.0"
    client_id               = var.CLIENT_ID
    client_secret           = var.CLIENT_SECRET
    tenant_id               = var.TENANT_ID
    subscription_id         = var.SUBSCRIPTION_ID
}
