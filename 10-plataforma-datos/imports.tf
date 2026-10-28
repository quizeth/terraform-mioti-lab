import {
  to = azurerm_resource_group.legacy
  id = "/subscriptions/${var.subscription_id}/resourceGroups/rg-legacy-${var.unique_suffix}"
}

resource "azurerm_resource_group" "legacy" {
  name     = "rg-legacy-${var.unique_suffix}"
  location = var.location
  tags = {
    project = "mioti"
    owner   = "desconocido"
  }
}
