variable "vnet_name" {
  description = "Name of the Virtual Network"
  type        = string

  validation {
    condition     = length(var.vnet_name) >= 2 && length(var.vnet_name) <= 64
    error_message = "VNET name must be between 2 and 64 characters."
  }
}

variable "address_space" {
  description = "List of address spaces for the VNET (e.g., [\"10.0.0.0/16\"])"
  type        = list(string)
}

variable "location" {
  description = "Azure region for the VNET"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group where the VNET will be created"
  type        = string
}

variable "subnets" {
  description = <<-EOT
    Map of subnets to create. Each subnet supports:
    - address_prefix: CIDR block for the subnet
    - nsg_rules: Optional list of NSG rules to add on top of the default deny-all-inbound baseline
  EOT
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

variable "tags" {
  description = "Map of tags to apply to all resources"
  type        = map(string)
  default     = {}
}

variable "flow_logs" {
  description = "Optional NSG flow log configuration. Set to null to disable."
  type = object({
    storage_account_id                = string
    retention_days                    = number
    log_analytics_workspace_id        = optional(string)
    log_analytics_workspace_resource_id = optional(string)
  })
  default = null
}
