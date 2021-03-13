output "bastion_public_ip" {
  value = azurerm_public_ip.dev-public-ip-bastion.ip_address
}

output "webserver_public_ip" {
  value = azurerm_public_ip.dev-public-ip-webserver.ip_address
}

output "bastion_private_ip" {
  value = azurerm_network_interface.bastion-host-nic.private_ip_address
}

output "web_private_ip" {
  value = azurerm_network_interface.web-host-nic.private_ip_address
}

output "app_private_ip" {
  value = azurerm_network_interface.app-host-nic.private_ip_address
}