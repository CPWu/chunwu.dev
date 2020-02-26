/***************************************************************************
* File Name: vars.tf
* Author: Chun Wu
* Email: the.chun.wu@gmail.com
* Date: 02/25/2020
*
* Purpose: Defines all the variables used by HCL (Terraform) code.
* 
*
***************************************************************************/

// Provider Credentials
variable "CLIENT_ID" {}
variable "CLIENT_SECRET" {}
variable "TENANT_ID" {}
variable "SUBSCRIPTION_ID" {}

// Infrastructure Variables
variable "RESOURCE_GROUP_NAME" {}

variable "AZURE_REGION" {
    default = "canadaeast"
    description = "The azure region that we will be using"
}