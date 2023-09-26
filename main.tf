# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.28.0"
    }
  }
}

resource "azurerm_resource_group" "resource_group" {
  name     = "TF-GH-RG"
  location = "West Europe"
}