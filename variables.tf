#Azure authentication variables
variable "azure_subscription_id" {
  type = string
  description = "Azure Subscription ID"
}

variable "azure_client_id" {
  type = string
  description = "Azure Client ID"
}

variable "azure_client_secret" {
  type = string
  description = "Azure Client Secret"
}

variable "azure_tenant_id" {
  type = string
  description = "Azure Tenant ID"
}

variable "location" {
    default = "eastus"
}

# Variables for Virtual Machines
variable "admin_username" {
    type = string
    description = "Administrator username for virtual machines"
    default = "azureadmin"
}

variable "admin_password" {
    type = string
    description = "Administrator password for virtual machines"
    default = ""
}

variable "sku" {
  default = {
    westus = "16.04-LTS"
    eastus = "18.04-LTS"
  }
}

# Variables for Network Security Groupps
variable "admin_ports" {
    default = ["22"]
}

variable "web_ports_ssl" {
    default = ["80", "443"]  
}

variable "allow-list" {
    type = map
    default = {
        "admin1" = ["100", "Admin1", "22", "<INTERNET-IP-ADDRESS-HERE>/32"]
        "admin2" = ["101", "Admin2", "22", "<INTERNET-IP-ADDRESS-HERE>/32"]
    }
}

# Define the prefix for your environment
variable "prefix" {
    default = "dev"
}

locals {
    resource_group_name = "${var.prefix}-rg"
}
