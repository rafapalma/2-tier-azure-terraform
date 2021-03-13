# Data template bash script for Web and App servers
data "template_file" "user-data-cloud-init" {
  template = file("./scripts/azure-user-data.sh")
}

# Create Bastion Host virtual machine
resource "azurerm_virtual_machine" "dev-bastion-host" {
  depends_on            = [azurerm_network_interface.bastion-host-nic]
  name                  = "${var.prefix}-bastion-host"
  location              = var.location
  resource_group_name   = azurerm_resource_group.dev-rg.name
  network_interface_ids = [azurerm_network_interface.bastion-host-nic.id]
  vm_size               = "Standard_DS1_v2"

  storage_os_disk {
    name              = "myBastionDisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
  }

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = lookup(var.sku, var.location)
    version   = "latest"
  }

  os_profile {
    computer_name  = "${var.prefix}-bastion"
    admin_username = var.admin_username
    admin_password = var.admin_password
  }

  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      key_data = file("./keys/<YOUR-PUBLIC-KEY-FILENAME-HERE>.pub")
      path = "/home/${var.admin_username}/.ssh/authorized_keys"
    }
  }
}

# Create Web Server virtual machine
resource "azurerm_virtual_machine" "dev-web-host" {
  depends_on            = [azurerm_network_interface.web-host-nic]
  name                  = "${var.prefix}-web-host"
  location              = var.location
  resource_group_name   = azurerm_resource_group.dev-rg.name
  network_interface_ids = [azurerm_network_interface.web-host-nic.id]
  vm_size               = "Standard_DS1_v2"

  storage_os_disk {
    name              = "myWebServerDisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
  }

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = lookup(var.sku, var.location)
    version   = "latest"
  }

  os_profile {
    computer_name  = "${var.prefix}-web"
    admin_username = var.admin_username
    admin_password = var.admin_password
    custom_data = base64encode(data.template_file.user-data-cloud-init.rendered)
  }

  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      key_data = file("./keys/<YOUR-PUBLIC-KEY-FILENAME-HERE>.pub")
      path = "/home/${var.admin_username}/.ssh/authorized_keys"
    }
  }
}

# Create App Server virtual machine
resource "azurerm_virtual_machine" "dev-app-host" {
  depends_on            = [azurerm_network_interface.app-host-nic]
  name                  = "${var.prefix}-app-host"
  location              = var.location
  resource_group_name   = azurerm_resource_group.dev-rg.name
  network_interface_ids = [azurerm_network_interface.app-host-nic.id]
  vm_size               = "Standard_DS1_v2"

  storage_os_disk {
    name              = "myAppServerDisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
  }

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = lookup(var.sku, var.location)
    version   = "latest"
  }

  os_profile {
    computer_name  = "${var.prefix}-app"
    admin_username = var.admin_username
    admin_password = var.admin_password
    custom_data = base64encode(data.template_file.user-data-cloud-init.rendered)
  }

  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      key_data = file("./keys/<YOUR-PUBLIC-KEY-FILENAME-HERE>.pub")
      path = "/home/${var.admin_username}/.ssh/authorized_keys"
    }
  }
}
