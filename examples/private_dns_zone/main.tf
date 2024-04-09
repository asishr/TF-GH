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