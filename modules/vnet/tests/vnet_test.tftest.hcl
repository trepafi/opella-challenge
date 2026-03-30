mock_provider "azurerm" {}

variables {
  vnet_name           = "vnet-test-dev-eastus"
  address_space       = ["10.0.0.0/16"]
  location            = "eastus"
  resource_group_name = "rg-test"
  tags = {
    environment = "test"
    project     = "opella"
  }
  subnets = {
    default = {
      address_prefix = "10.0.0.0/24"
    }
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
          source_address_prefix      = "*"
          destination_address_prefix = "*"
        }
      ]
    }
  }
}

# Test: VNET is created with the correct name and address space
run "vnet_created_with_correct_values" {
  command = plan

  assert {
    condition     = azurerm_virtual_network.this.name == "vnet-test-dev-eastus"
    error_message = "VNET name does not match expected value"
  }

  assert {
    condition     = azurerm_virtual_network.this.address_space[0] == "10.0.0.0/16"
    error_message = "VNET address space does not match expected value"
  }

  assert {
    condition     = azurerm_virtual_network.this.location == "eastus"
    error_message = "VNET location does not match expected value"
  }
}

# Test: Correct number of subnets are created
run "correct_number_of_subnets" {
  command = plan

  assert {
    condition     = length(azurerm_subnet.this) == 2
    error_message = "Expected 2 subnets to be created"
  }
}

# Test: NSGs are created for all subnets
run "nsgs_created_for_all_subnets" {
  command = plan

  assert {
    condition     = length(azurerm_network_security_group.this) == 2
    error_message = "Expected 2 NSGs (one per subnet)"
  }
}

# Test: Custom NSG rules are applied
run "custom_nsg_rules_applied" {
  command = plan

  assert {
    condition     = length(azurerm_network_security_rule.this) == 1
    error_message = "Expected 1 custom NSG rule (AllowSSH on vm subnet)"
  }
}

# Test: NSG-subnet associations are created
run "nsg_subnet_associations_created" {
  command = plan

  assert {
    condition     = length(azurerm_subnet_network_security_group_association.this) == 2
    error_message = "Expected 2 NSG-subnet associations"
  }
}

# Test: Tags are propagated to resources
run "tags_propagated" {
  command = plan

  assert {
    condition     = azurerm_virtual_network.this.tags["project"] == "opella"
    error_message = "Tags not propagated to VNET"
  }

  assert {
    condition     = azurerm_virtual_network.this.tags["environment"] == "test"
    error_message = "Environment tag not propagated to VNET"
  }
}

# Test: Subnet with no custom rules still gets an NSG (secure-by-default)
run "subnet_without_rules_gets_nsg" {
  command = plan

  variables {
    subnets = {
      isolated = {
        address_prefix = "10.0.2.0/24"
      }
    }
  }

  assert {
    condition     = length(azurerm_network_security_group.this) == 1
    error_message = "Subnet without custom rules should still get an NSG"
  }

  assert {
    condition     = length(azurerm_network_security_rule.this) == 0
    error_message = "Subnet without custom rules should have no additional NSG rules"
  }
}

# Test: VNET name validation (too short)
run "vnet_name_validation_too_short" {
  command = plan

  variables {
    vnet_name = "a"
  }

  expect_failures = [
    var.vnet_name,
  ]
}
