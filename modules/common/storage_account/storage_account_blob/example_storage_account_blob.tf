provider "azurerm" {
  features {}
}

provider "azuread" {
}


module "environment_variables" {
  source           = "../../../../tools/environment_variables/v1"
  environment      = "dev"
  cost_center      = "1234"
  application_name = ""
}

module "example_rg" {
  source   = "../../../../common/resource_group/v1"
  name     = "example-rgn"
  location = "Canada Central"
}

module "example_storage" {
  source                          = "../../../../storage/storage_account/v1"
  name                            = "examplestorageacnt"
  resource_group_name             = module.example_rg.name
  location                        = "Canada Central"
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  access_tier                     = "Cool"
  enable_https_traffic_only       = false
  min_tls_version                 = "TLS1_2"
  allow_nested_items_to_be_public = false
  is_hns_enabled                  = false
  nfsv3_enabled                   = false
  large_file_share_enabled        = false

  blob_properties = {
    versioning_enabled            = true
    change_feed_enabled           = true
    change_feed_retention_in_days = 1
    default_service_version       = "2020-06-12"
    last_access_time_enabled      = true

    cors_rule = {
      allowed_headers    = ["cookie1"]
      allowed_methods    = ["DELETE", "GET", "HEAD", "MERGE", "POST", "OPTIONS", "PUT", "PATCH"]
      allowed_origins    = ["www.origindomain.com"]
      exposed_headers    = ["cookie2"]
      max_age_in_seconds = 2
    }
    delete_retention_policy = {
      days = 7
    }
    container_delete_retention_policy = {
      days = 7
    }
  }

  containers = [
    {
      name = "cont1"

      metadata = {
        metak1 = "metav1"
      }

      role_assignments = {
        Reader = [
          {
            user_name      = "svcdcls2@core.com"
            principal_id   = "c01aaeed-f27f-4ec0-8976-abdadfc20ee7"
            skip_aad_check = false
          },
          {
            group_name     = "acl_stdlf_Access"
            principal_id   = "a6db748c-a431-4356-8a23-59624b21e6e4"
            skip_aad_check = false
          }
        ]

        "Backup Operator" = [
          {
            user_name      = "svcdcls2@core.com"
            principal_id   = "c01aaeed-f27f-4ec0-8976-abdadfc20ee7"
            skip_aad_check = false
          },
          {
            serviceprincipal_name = "Apigee"
            principal_id          = "3d564258-5c36-4595-9d48-a6a17b240734"
            skip_aad_check        = false
          },
          {
            user_name      = "benalno@core.com"
            principal_id   = "9ad6f943-730d-497d-b8f3-89a208c92407"
            skip_aad_check = false
          }
        ]
      }

      blobs = [{
        name        = "blob1"
        type        = "Block"
        size        = "512"
        access_tier = "Hot"
        parallelism = 2
        # cache_control  = "" (Optional) Controls the cache control header content of the response when blob is requested .
        # content_md5 = "" (Optional) The MD5 sum of the blob contents. Cannot be defined if source_uri is defined, or if blob type is Append or Page. Changing this forces a new resource to be created.      

        role_assignments = {
          "DevTest Labs User" = [
            {
              user_name      = "svcdcls5@core.com"
              principal_id   = "c01aaeed-f27f-4ec0-8976-abdadfc20ee7"
              skip_aad_check = false
            },
            {
              group_name     = "acl_stdlf_Access"
              principal_id   = "a6db748c-a431-4356-8a23-59624b21e6e4"
              skip_aad_check = false
            }
          ]

          "Log Analytics Contributor" = [{
            user_name      = "benalno@core.com"
            principal_id   = "9ad6f943-730d-497d-b8f3-89a208c92407"
            skip_aad_check = false
          }]
        }
      }]
    },
    {
      name                  = "cont2"
      container_access_type = "private"

      blobs = [
        {
          name        = "blob21"
          type        = "Block"
          size        = "512"
          access_tier = "Cool"
        },
        {
          name        = "blob22"
          type        = "Block"
          size        = "512"
          access_tier = "Cool"
        }
      ]
    }
  ]
}
