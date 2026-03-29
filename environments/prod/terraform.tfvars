location    = "westeurope"
environment = "prod"
project     = "opella"
owner       = "devops-team"

vm_size                  = "Standard_B1s"
storage_replication_type = "GRS"

vnet_address_space = ["10.1.0.0/16"]

subnets = {
  default = {
    address_prefix = "10.1.0.0/24"
  }
  vm = {
    address_prefix = "10.1.1.0/24"
    nsg_rules = [
      {
        name                       = "AllowSSHFromVnet"
        priority                   = 100
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "VirtualNetwork"
        destination_address_prefix = "*"
      }
    ]
  }
}
