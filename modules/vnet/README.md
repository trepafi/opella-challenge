<!-- BEGIN_TF_DOCS -->
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

### Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.9.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 3.0 |

### Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~> 3.0 |

### Resources

| Name | Type |
|------|------|
| [azurerm_network_security_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group) | resource |
| [azurerm_network_security_rule.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) | resource |
| [azurerm_subnet.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet_network_security_group_association.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association) | resource |
| [azurerm_virtual_network.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) | resource |

### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_address_space"></a> [address\_space](#input\_address\_space) | List of address spaces for the VNET (e.g., ["10.0.0.0/16"]) | `list(string)` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | Azure region for the VNET | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Name of the resource group where the VNET will be created | `string` | n/a | yes |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | Map of subnets to create. Each subnet supports:<br/>- address\_prefix: CIDR block for the subnet<br/>- nsg\_rules: Optional list of NSG rules to add on top of the default deny-all-inbound baseline | <pre>map(object({<br/>    address_prefix = string<br/>    nsg_rules = optional(list(object({<br/>      name                       = string<br/>      priority                   = number<br/>      direction                  = string<br/>      access                     = string<br/>      protocol                   = string<br/>      source_port_range          = string<br/>      destination_port_range     = string<br/>      source_address_prefix      = string<br/>      destination_address_prefix = string<br/>    })), [])<br/>  }))</pre> | n/a | yes |
| <a name="input_vnet_name"></a> [vnet\_name](#input\_vnet\_name) | Name of the Virtual Network | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Map of tags to apply to all resources | `map(string)` | `{}` | no |

### Outputs

| Name | Description |
|------|-------------|
| <a name="output_nsg_ids"></a> [nsg\_ids](#output\_nsg\_ids) | Map of subnet names to their NSG IDs |
| <a name="output_subnet_ids"></a> [subnet\_ids](#output\_subnet\_ids) | Map of subnet names to their IDs |
| <a name="output_subnet_names"></a> [subnet\_names](#output\_subnet\_names) | List of subnet names |
| <a name="output_vnet_id"></a> [vnet\_id](#output\_vnet\_id) | The ID of the Virtual Network |
| <a name="output_vnet_name"></a> [vnet\_name](#output\_vnet\_name) | The name of the Virtual Network |
<!-- END_TF_DOCS -->