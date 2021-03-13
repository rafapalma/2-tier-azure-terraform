# Create a Virtual Network
resource "azurerm_virtual_network" "dev-vnet" {
    name = "${var.prefix}-vnet"
    address_space = [ "10.1.0.0/16" ]
    location = var.location
    resource_group_name = azurerm_resource_group.dev-rg.name
}

# Create public subnet
resource "azurerm_subnet" "dev-public-subnet" {
    name = "${var.prefix}-public-subnet"
    resource_group_name = azurerm_resource_group.dev-rg.name
    virtual_network_name = azurerm_virtual_network.dev-vnet.name
    address_prefixes = [ "10.1.10.0/24" ]
}

# Create private subnet
resource "azurerm_subnet" "dev-private-subnet" {
    name = "${var.prefix}-private-subnet"
    resource_group_name = azurerm_resource_group.dev-rg.name
    virtual_network_name = azurerm_virtual_network.dev-vnet.name
    address_prefixes = [ "10.1.20.0/24" ]
}

# Create public IP for Bastion Host
resource "azurerm_public_ip" "dev-public-ip-bastion" {
  name                = "${var.prefix}-public-ip-bastion"
  location            = var.location
  resource_group_name = azurerm_resource_group.dev-rg.name
  allocation_method   = "Static"
}

# Create public IP for Web Server
resource "azurerm_public_ip" "dev-public-ip-webserver" {
  name                = "${var.prefix}-public-ip-webserver"
  location            = var.location
  resource_group_name = azurerm_resource_group.dev-rg.name
  allocation_method   = "Static"
}

# Create network interface for Bastion Host
resource "azurerm_network_interface" "bastion-host-nic" {
  depends_on          = [ azurerm_public_ip.dev-public-ip-bastion ]
  name                = "bastion-host-nic"
  location            = var.location
  resource_group_name = azurerm_resource_group.dev-rg.name

  ip_configuration {
    name                          = "bastion-host-nic-config"
    subnet_id                     = azurerm_subnet.dev-public-subnet.id
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = azurerm_public_ip.dev-public-ip-bastion.id
  }
}

# Create network interface for Web Server
resource "azurerm_network_interface" "web-host-nic" {
  depends_on          = [ azurerm_public_ip.dev-public-ip-webserver ]
  name                = "web-host-nic"
  location            = var.location
  resource_group_name = azurerm_resource_group.dev-rg.name

  ip_configuration {
    name                          = "web-host-nic-config"
    subnet_id                     = azurerm_subnet.dev-public-subnet.id
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = azurerm_public_ip.dev-public-ip-webserver.id
  }
}

# Create network interface for App Server
resource "azurerm_network_interface" "app-host-nic" {
  name                = "app-host-nic"
  location            = var.location
  resource_group_name = azurerm_resource_group.dev-rg.name

  ip_configuration {
    name                          = "app-host-nic-config"
    subnet_id                     = azurerm_subnet.dev-private-subnet.id
    private_ip_address_allocation = "dynamic"
  }
}