resource "azurerm_resource_group" "rgblock" {
  name = "rg-new-devops"
  location = "Central India"
}
resource "azurerm_resource_group" "rgblock2" {
  name = "rg-new-devops2"
  location = "Central India"
}

resource "azurerm_virtual_network" "vnetblock" {
  name = "rg-new-vnet"
  resource_group_name = azurerm_resource_group.rgblock.name
  location = azurerm_resource_group.rgblock.location
  address_space = ["10.0.0.0/16"]
}
resource "azurerm_subnet" "subnetblock" {
  name = "rg-new-subnet"
  virtual_network_name = azurerm_virtual_network.vnetblock.name
  resource_group_name = azurerm_resource_group.rgblock.name
  address_prefixes = ["10.0.0.0/24"]
}
resource "azurerm_network_interface" "nicblock" {
  name = "rg-new-nic"
  resource_group_name = azurerm_resource_group.rgblock.name
  location = azurerm_resource_group.rgblock.location

  ip_configuration {
    name = "internal"
    subnet_id = azurerm_subnet.subnetblock.id
    private_ip_address_allocation = "Dynamic"
    }
}
resource "azurerm_linux_virtual_machine" "vmblock" {
  name = "rg-new-vm"
  resource_group_name = azurerm_resource_group.rgblock.name
  location = azurerm_resource_group.rgblock.location
  size = "Standard_B2ats_v2"
  admin_username = "adminuser"
  admin_password = "password@12345"
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.nicblock.id
  ]
  os_disk {
    caching = "ReadWrite"
    storage_account_type = "Standard_LRS"
    }
  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}
resource "azurerm_public_ip" "pipblock" {
  name = "rg-new-pip"
  resource_group_name = azurerm_resource_group.rgblock.name
  location = azurerm_resource_group.rgblock.location
  allocation_method = "Static"

  tags = { 
    environment = "Production"
  }
}
resource "azurerm_network_security_group" "nsgblock" {
  name = "rg-new-nsg"
  resource_group_name = azurerm_resource_group.rgblock.name
  location = azurerm_resource_group.rgblock.location

  security_rule {
    name = "rule123"
    priority = "100"
    direction = "Inbound"
    access = "Allow"
    protocol = "Tcp"
    source_port_range = "*"
    destination_port_range = "*"
    source_address_prefix = "*"
    destination_address_prefix = "*"
  }
}