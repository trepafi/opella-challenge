# Azure VNET Module

Reusable Terraform module for provisioning an Azure Virtual Network with configurable subnets and Network Security Groups.

## Features

- Configurable address space and subnets (flexible map input)
- NSG per subnet with secure-by-default baseline (deny all inbound, allow all outbound)
- Consumer-provided NSG rules layered on top of defaults
- Consistent tagging across all resources

## Usage

```hcl
module "vnet" {
  source = "../../modules/vnet"

  vnet_name           = "vnet-myproject-dev-eastus"
  address_space       = ["10.0.0.0/16"]
  location            = "eastus"
  resource_group_name = azurerm_resource_group.this.name

  subnets = {
    vm = {
      address_prefix = "10.0.1.0/24"
      nsg_rules = [
        {
          name                       = "AllowSSH"
          priority                   = 100
          direction                  = "Inbound"
          access                     = "Allow"
          protocol                   = "Tcp"
          source_port_range          = "*"
          destination_port_range     = "22"
          source_address_prefix      = "YOUR_IP/32"
          destination_address_prefix = "*"
        }
      ]
    }
    storage = {
      address_prefix = "10.0.2.0/24"
    }
  }

  tags = {
    environment = "dev"
    project     = "myproject"
    managed_by  = "terraform"
  }
}
```
