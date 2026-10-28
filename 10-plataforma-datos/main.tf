locals {
  base         = "${var.project}-${var.environment}-${var.unique_suffix}"
  sql_location = coalesce(var.sql_location, var.location)
  tags = {
    project     = var.project
    environment = var.environment
    owner       = var.owner
    cost_center = var.cost_center
    managed_by  = "terraform"
  }
}

data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "data" {
  name     = "rg-${local.base}"
  location = var.location
  tags     = local.tags
}
