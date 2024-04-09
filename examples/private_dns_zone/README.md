# Azure - Private DNS Zone Module

## Introduction

This module can create Azure Private DNS Zone and manage DNS A Records within Azure DNS


# Examples
`terraform apply`

main.tf:
```
# Azure Provider configuration
provider "azurerm" {
  features {}
}

module "dns_zones" {
  source              = "../../modules/networking/private_dns_zone"
  resource_group_name = "IGM-MGMT-Dev-RG"
  priv_dns_name       = "test-dns.mysite.com"
  records = {
    a_records = {
      testa1 = {
        name    = "*"
        ttl     = 3600
        records = ["1.1.1.1", "2.2.2.2"]
      }
      testa2 = {
        name    = "@"
        ttl     = 3600
        records = ["1.1.1.1", "2.2.2.2"]
      }
    }

    txt_records = {
      testtxt1 = {
        name = "testtxt1"
        ttl  = 3600
        records = {
          r1 = {
            value = "testing txt 1"
          }
          r2 = {
            value = "testing txt 2"
          }
        }
      }
    }
  }
  tags = {
    businessUnit = "HR"
    environment  = "Production"
    costcenter   = "123456"
  }
}

```

# Resources Created
This modules creates:
* 1 Azure Private DNS Zone
* 2 DNS A Records within Azure DNS
* 3 DNS AAAA Records within Azure DNS
* 4 DNS CNAME Records within Azure DNS
* 5 DNS MX Records within Azure DNS
* 6 DNS PTR Records within Azure DNS
* 7 DNS SRV Records within Azure DN
* 8 DNS TXT Records within Azure DNS


<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12 |
| azurerm | >= 2.60.0 |


## Providers

| Name | Version |
|------|---------|
| azurerm | >= 3.0.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| priv\_dns\_name | Specifies the DNS Zone where the resource exists. Changing this forces a new resource to be created | `string` | n/a | yes |
| resource\_group\_name | Specifies the resource group where the DNS Zone (parent resource) exists. Changing this forces a new resource to be created | `string` | n/a | yes |
| tags | A map of the tags to use on the resources that are deployed with this module | `map(string)` | `{}` | yes |
| records | List of IPv4 Addresses. Conflicts with target_resource_id | `any` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| id | DNS Zone resource ID |
| name | The fully qualified domain name of the Record Set |
| resource_group_name | Resource group name of the dns_zone |
| max_number_of_record_sets | Maximum number of Records in the zone |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->


# References
This repo is based on:
* [terraform standard module structure](https://www.terraform.io/docs/modules/index.html#standard-module-structure)

## Reference documents:
* Azure Private DNS Zone documentation (Azure Documentation: https://learn.microsoft.com/en-us/azure/dns/private-dns-privatednszone)
* Azure Private DNS Zone Terraform Docs: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone
* Azure DNS A Records Terraform Docs: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/dns_a_record
* Azure DNS AAAA Records Terraform Docs: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/dns_aaaa_record
* Azure DNS CNAME Records Terraform Docs: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/dns_cname_record
* Azure DNS MX Records Terraform Docs: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/dns_mx_record
* Azure DNS PTR Records Terraform Docs: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/dns_ptr_record
* Azure DNS SRV Records Terraform Docs: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/dns_srv_record
* Azure DNS TXT Records Terraform Docs: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/dns_txt_record


