variable subnet_name {
  description = "(Required) The required Azure Subnet details for the new Private Endpoint NIC."
  type = string
}

variable virtual_network_name {
  description = "(Required) The required Azure Virtual Network Name for the new Private Endpoint."
  type = string

}

variable resource_group_name {
  description = "(Required) The required Azure Virtual Network Name for the new Private Endpoint."
  type = string

}

variable "subresource_names" {
  description = "(Required) A list of subresource names which the Private Endpoint is able to connect to. subresource_names corresponds to group_id."
  type = list(string)
}

variable  private_endpoint_name  {
  description = "(Required) Specifies the Name of the Private Endpoint. Changing this forces a new resource to be created."
  type = string
}

variable pe_resource_group_name {
  description = "(Required) A container (resource group) that holds related resources for private endpoints."
  type = string
}

variable "location" {
  description = "(Required) The location/region to keep all your network resources. To get the list of all locations with table format from azure cli, run 'az account list-locations -o table'"
  type        = string
  default     = "canadacentral"
}

variable "endpoint_resource_id" {
  description = " (Optional) The ID of the Private Link Enabled Remote Resource which this Private Endpoint should be connected to."
  type        = string
  default     = null
}

variable "tags" {
  description = "(Required) A map of tags to add to all resources"
  type        = map(string)
}

variable "dns" {
  description = "(Required) Azure Private DNS zone details for the Azure Private Link."
  type = object({
    zone_ids  = list(string)
    zone_name = string
    })
}

variable zone_info {
  description = " (Optional) The list of the Private DNS Zone Supported."
  type = map
  default = {
    "registry"                  = "privatelink.azurecr.io"
    "sites"                     = "privatelink.azurewebsites.net"
    "blob"                      = "privatelink.blob.core.windows.net"
    "sqlServer"                 = "privatelink.database.windows.net"
    "Sql"                       = "privatelink.documents.azure.com"
    "file"                      = "privatelink.file.core.windows.net"
    "vault"                     = "privatelink.vaultcore.azure.net"
    "dfs"                       = "privatelink.dfs.core.windows.net"
    "dataFactory"               = "privatelink.datafactory.azure.net"
    "table"                     = "privatelink.table.core.windows.net"
    "redisCache"                = "privatelink.redis.cache.windows.net"
    "topic"                     = "privatelink.eventgrid.azure.net" 
    "azuremonitor"              = "privatelink.monitor.azure.com"
    "postgresqlServer"          = "privatelink.postgres.database.azure.com"
    "namespace"                 = "privatelink.servicebus.windows.net"
    "account"                   = "privatelink.purview.azure.com"
    "adf"                       = "privatelink.adf.azure.com"
    "SqlSyn"                    = "privatelink.sql.azuresynapse.net"
    "SqlOnDemand"               = "privatelink.sql.azuresynapse.net"
    "DevSyn"                    = "privatelink.dev.azuresynapse.net"
    "WebSyn"                    = "privatelink.azuresynapse.net"
    "amlworkspace"              = "privatelink.api.azureml.ms"
  }
}


  



