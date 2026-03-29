variable "location" {
  description = "Azure region for this environment"
  type        = string
}

variable "environment" {
  description = "Environment name (e.g., dev, prod)"
  type        = string
}

variable "project" {
  description = "Project name used in resource naming"
  type        = string
}

variable "owner" {
  description = "Team or person responsible for these resources"
  type        = string
}

variable "vm_size" {
  description = "Azure VM size"
  type        = string
  default     = "Standard_B1s"
}

variable "vm_admin_username" {
  description = "Admin username for the Linux VM"
  type        = string
  default     = "azureuser"
}

variable "storage_replication_type" {
  description = "Storage account replication type (LRS, GRS, etc.)"
  type        = string
  default     = "LRS"
}

variable "vnet_address_space" {
  description = "Address space for the VNET"
  type        = list(string)
}

variable "subnets" {
  description = "Map of subnets to create in the VNET"
  type = map(object({
    address_prefix = string
    nsg_rules = optional(list(object({
      name                       = string
      priority                   = number
      direction                  = string
      access                     = string
      protocol                   = string
      source_port_range          = string
      destination_port_range     = string
      source_address_prefix      = string
      destination_address_prefix = string
    })), [])
  }))
}
