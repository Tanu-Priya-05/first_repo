resource "azurerm_public_ip" "PIA" {
  name                = var.IP_name
  resource_group_name = var.rg_name
  location            = var.IP_location
  allocation_method   = var.allocation_method
}