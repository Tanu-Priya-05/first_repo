module "resource_G" {
  source      = "../Module/resource_group"
  rg_name     = "tanu_todo"
  rg_location = "east us"
}

module "virtual_network" {
  depends_on          = [module.resource_G]
  source              = "../Module/V_net"
  vnet_name           = "todo-net"
  resource_group_name = "tanu_todo"
  address_space       = ["10.0.0.0/16"]
  vnet_location       = "east us"
}

module "frontEnd_subnet" {
  depends_on           = [module.virtual_network]
  source               = "../Module/Sub_net"
  subnet_name          = "front-snet"
  resource_group_name  = "tanu_todo"
  virtual_network_name = "todo-net"
  address_prefixes     = ["10.0.1.0/24"]
}

module "backEnd_subnet" {
  depends_on           = [module.virtual_network]
  source               = "../Module/Sub_net"
  subnet_name          = "backend-snet"
  resource_group_name  = "tanu_todo"
  virtual_network_name = "todo-net"
  address_prefixes     = ["10.0.2.0/24"]
}

module "Public_IP" {
  depends_on = [ module.resource_G ]
  source = "../Module/Public_IP"
  IP_name = "ip_todo"
  rg_name = "tanu_todo"
  IP_location = "east us"
  allocation_method = "Static"
}
module "Public_PIP" {
  depends_on = [ module.resource_G ]
  source = "../Module/Public_IP"
  IP_name = "pip_todo"
  rg_name = "tanu_todo"
  IP_location = "east us"
  allocation_method = "Static"
}

module "frontend_VM"{
  depends_on = [module.frontEnd_subnet, module.virtual_network, module.Public_IP]
  source = "../Module/V_M"
  nic_name = "tanu_nic"
  nic_location = "east us"
  resource_name = "tanu_todo"
  config_name = "internal"
  private_ip = "Dynamic"
  vm_name = "tanu-vm-front"
  rg_name = "tanu_todo"
  vm_location = "east us"
  vm_size = "Standard_B2s"
  admin_user = "Tanu_123"
  admin_password = "BeHonest2u@20"
  disk_caching = "ReadWrite"
  storage_account_type = "Standard_LRS"
  image_publisher = "Canonical"
  image_offer = "0001-com-ubuntu-server-jammy"
  image_sku = "22_04-lts"
  image_version = "latest"
  virtual_network_name = "todo-net"
  subnet_name = "front-snet"
  pip_name = "ip_todo"
}

module "backend_VM"{
  depends_on = [module.backEnd_subnet, module.virtual_network, module.Public_PIP]
  source = "../Module/V_M"
  nic_name = "tanu_nic_back"
  nic_location = "east us"
  resource_name = "tanu_todo"
  config_name = "internal"
   private_ip = "Dynamic"
  vm_name = "tanu-vm-back"
  rg_name = "tanu_todo"
  vm_location = "east us"
  vm_size = "Standard_B2s"
  admin_user = "Tanu_1234"
  admin_password = "BeHonest2u@05"
  disk_caching = "ReadWrite"
  storage_account_type = "Standard_LRS"
  image_publisher = "Canonical"
  image_offer = "0001-com-ubuntu-server-focal"
  image_sku = "20_04-lts"
  image_version = "latest"
  virtual_network_name = "todo-net"
  subnet_name = "backend-snet"
  pip_name = "pip_todo"
}


module "sql_server"{
  depends_on = [ module.resource_G ]
  source = "../Module/Sql_Server"
  sql_name = "todosqltanu"
  rg_name = "tanu_todo"
  sql_version = "12.0"
  rg_location = "east us"
  administrator_login = "Tanu_12345"
  administrator_password = "BeHonest2u@07"
}

module "sql_Database" {
  depends_on = [module.sql_server] 
  source = "../Module/Sql_Database"
  db_name = "todo-db"
  sql_server_name = "todosqltanu"
  rg_name = "tanu_todo"
}

module "key_vault" {
  depends_on = [module.resource_G]
  kv_name = "tanu-keyyyy"
  source = "../Module/key_vault"
  kv_location = "east us"
  rg_name = "tanu_todo"
}