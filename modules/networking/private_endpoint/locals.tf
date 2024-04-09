locals {
    zone_name = [for subresource in var.subresource_names: 
                lookup(var.zone_info,subresource )]
}