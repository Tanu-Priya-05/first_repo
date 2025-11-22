  resource "azurerm_network_interface" "NIC" {
  name                = var.nic_name
  location            = var.nic_location
  resource_group_name = var.rg_name

  ip_configuration {
    name                          = var.config_name
    subnet_id                     = data.azurerm_subnet.subnet.id
    private_ip_address_allocation = var.private_ip
    public_ip_address_id          = data.azurerm_public_ip.DPIP.id
  }
} 

resource "azurerm_linux_virtual_machine" "VM" {
  name                = var.vm_name
  resource_group_name = var.rg_name
  location            = var.vm_location
  size                = var.vm_size
  admin_username      = var.admin_user
  admin_password      = var.admin_password
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.NIC.id,
  ]

  os_disk {
    caching              = var.disk_caching
    storage_account_type = var.storage_account_type
  }

  source_image_reference {
    publisher = var.image_publisher  #published id
    offer     = var.image_offer      #product id
    sku       = var.image_sku        #plan id
    version   = var.image_version
  }

  custom_data = base64encode(<<-EOF
  #!/bin/bash
  sudo apt-get update -y
  sudo apt-get install -y nginx
  sudo systemctl enable nginx
  sudo systemctl start nginx
  EOF
  )

}