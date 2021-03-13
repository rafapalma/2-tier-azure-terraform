# Create Network Security Group for Bastion Host
resource "azurerm_network_security_group" "dev-public-nsg-bastion" {
    name                = "${var.prefix}-public-nsg-bastion"
    location            = var.location
    resource_group_name = azurerm_resource_group.dev-rg.name
}

# Create Network Security Group for Web Server
resource "azurerm_network_security_group" "dev-public-nsg-web" {
    name                = "${var.prefix}-public-nsg-web"
    location            = var.location
    resource_group_name = azurerm_resource_group.dev-rg.name
}

# Create Network Security Group for App Server
resource "azurerm_network_security_group" "dev-private-nsg-app" {
    name                = "${var.prefix}-private-nsg-app"
    location            = var.location
    resource_group_name = azurerm_resource_group.dev-rg.name
}

# Create Network Security Group Ingress Rule for Bastion Host
resource "azurerm_network_security_rule" "dev-public-nsg-bastion-ingress-admin" {
    for_each = var.allow-list
    name = each.value[1]
    priority = each.value[0]
    direction = "Inbound"
    access = "Allow"
    protocol = "Tcp"
    source_port_range = "*"
    destination_port_range = each.value[2]
    source_address_prefix = each.value[3]
    destination_address_prefix = "*"
    resource_group_name = azurerm_resource_group.dev-rg.name
    network_security_group_name = azurerm_network_security_group.dev-public-nsg-bastion.name
}

# Create Network Security Group Ingress Rule for Web Server
resource "azurerm_network_security_rule" "dev-public-nsg-web-ingress-webports" {
    name = "Web Traffic"
    priority = 100
    direction = "Inbound"
    access = "Allow"
    protocol = "Tcp"
    source_port_range = "*"
    destination_port_ranges = var.web_ports_ssl
    source_address_prefix = "*"
    destination_address_prefix = "*"
    resource_group_name = azurerm_resource_group.dev-rg.name
    network_security_group_name = azurerm_network_security_group.dev-public-nsg-web.name
}

resource "azurerm_network_security_rule" "dev-public-nsg-web-ingress-admin" {
    name = "SSH"
    priority = 110
    direction = "Inbound"
    access = "Allow"
    protocol = "Tcp"
    source_port_range = "*"
    destination_port_ranges = var.admin_ports
    source_address_prefix = azurerm_network_interface.bastion-host-nic.private_ip_address
    destination_address_prefix = "*"
    resource_group_name = azurerm_resource_group.dev-rg.name
    network_security_group_name = azurerm_network_security_group.dev-public-nsg-web.name
}

resource "azurerm_network_security_rule" "dev-public-nsg-web-ingress-admin-deny" {
    name = "SSH"
    priority = 115
    direction = "Inbound"
    access = "Deny"
    protocol = "Tcp"
    source_port_range = "*"
    destination_port_ranges = var.admin_ports
    source_address_prefixes = azurerm_subnet.dev-public-subnet.address_prefixes
    destination_address_prefix = "*"
    resource_group_name = azurerm_resource_group.dev-rg.name
    network_security_group_name = azurerm_network_security_group.dev-public-nsg-web.name
}

# Create Network Security Group Ingress Rule for App Server
resource "azurerm_network_security_rule" "dev-private-nsg-app-ingress-webports" {
    name = "Web Traffic"
    priority = 100
    direction = "Inbound"
    access = "Allow"
    protocol = "Tcp"
    source_port_range = "*"
    destination_port_ranges = var.web_ports_ssl
    source_address_prefix = azurerm_network_interface.web-host-nic.private_ip_address
    destination_address_prefix = "*"
    resource_group_name = azurerm_resource_group.dev-rg.name
    network_security_group_name = azurerm_network_security_group.dev-private-nsg-app.name
}

resource "azurerm_network_security_rule" "dev-private-nsg-app-ingress-admin" {
    name = "SSH"
    priority = 110
    direction = "Inbound"
    access = "Allow"
    protocol = "Tcp"
    source_port_range = "*"
    destination_port_ranges = var.admin_ports
    source_address_prefix = azurerm_network_interface.bastion-host-nic.private_ip_address
    destination_address_prefix = "*"
    resource_group_name = azurerm_resource_group.dev-rg.name
    network_security_group_name = azurerm_network_security_group.dev-private-nsg-app.name
}

# Create Network Security Group Association for Bastion Host
resource "azurerm_network_interface_security_group_association" "nsg-bastion-ingress" {
  depends_on                = [ azurerm_network_security_group.dev-public-nsg-bastion ]
  network_interface_id      = azurerm_network_interface.bastion-host-nic.id
  network_security_group_id = azurerm_network_security_group.dev-public-nsg-bastion.id
}

# Create Network Security Group Association for Web Server
resource "azurerm_network_interface_security_group_association" "nsg-web-ingress" {
  depends_on                = [ azurerm_network_security_group.dev-public-nsg-web ]
  network_interface_id      = azurerm_network_interface.web-host-nic.id
  network_security_group_id = azurerm_network_security_group.dev-public-nsg-web.id
}

# Create Network Security Group Association for App Server
resource "azurerm_network_interface_security_group_association" "nsg-app-ingress" {
  depends_on                = [ azurerm_network_security_group.dev-private-nsg-app ]
  network_interface_id      = azurerm_network_interface.app-host-nic.id
  network_security_group_id = azurerm_network_security_group.dev-private-nsg-app.id
}
