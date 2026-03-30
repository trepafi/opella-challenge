include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  env = read_terragrunt_config(find_in_parent_folders("env.hcl"))
}

terraform {
  source = "../../../modules/vnet"
}

inputs = {
  vnet_name           = "vnet-${local.env.locals.project}-${local.env.locals.environment}-${local.env.locals.location}"
  address_space       = ["10.1.0.0/16"]
  location            = local.env.locals.location
  resource_group_name = "rg-${local.env.locals.project}-${local.env.locals.environment}-${local.env.locals.location}"

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

  tags = {
    environment = local.env.locals.environment
    project     = local.env.locals.project
    owner       = local.env.locals.owner
    managed_by  = "terraform"
  }
}
