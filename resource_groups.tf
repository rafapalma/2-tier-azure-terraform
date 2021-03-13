resource "azurerm_resource_group" "dev-rg" {
    name = "${var.prefix}-rg"
    location = var.location

    tags = {
        Environment = "2 Tier Deployment in Azure"
    }
}