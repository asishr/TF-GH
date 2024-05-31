package storage_account

import (
	"helper"
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
)

func Test_StorageAccount_All(t *testing.T) {
	// Configure Terraform helper;
	helperOptions := &helper.Options{
		AddProviders: true,
		TerraformOptions: &terraform.Options{
			Vars: map[string]interface{}{ // List of variables to be passed to terraform;
				"name":                            "nonprodunittestsa",
				"resource_group_name":             "unit-testing",
				"location":                        "Canada Central",
				"account_tier":                    "Standard",
				"account_replication_type":        "LRS",
				"account_kind":                    "Storage",
				"access_tier":                     "Cool",
				"enable_https_traffic_only":       "false",
				"min_tls_version":                 "TLS1_2",
				"allow_nested_items_to_be_public": "false",
				"is_hns_enabled":                  "false",
				"nfsv3_enabled":                   "false",
				"routing":                         `{ publish_internet_endpoints = "false" , publish_microsoft_endpoints = "false" ,   choice = "InternetRouting" }`,
				"custom_domain":                   `{domain_name   = "test.core.com" , use_subdomain = true }`,
				"identity":                        `{ type = "SystemAssigned" }`,
				"blob_properties":                 `{cors_rule = { allowed_headers =  ["cookie1"] , allowed_methods= ["DELETE", "GET", "HEAD", "MERGE", "POST", "OPTIONS", "PUT", "PATCH"] , allowed_origins =  ["www.origindomain.com"] ,  exposed_headers = ["cookie2"] , max_age_in_seconds =  2 ,} , delete_retention_policy = { days = 7 }, } `,
				"queue_properties": `{
						cors_rule = { allowed_headers    = ["httpheader1"] , allowed_methods    = ["DELETE", "GET", "HEAD", "MERGE", "POST", "OPTIONS", "PUT"] , allowed_origins    = ["www.toto2.com"] , exposed_headers    = ["header4"] , max_age_in_seconds   = 3 ,}
						logging = { delete = true , read = true , version = "1" , write = true , retention_policy_days = 4 ,}
						minute_metrics = { enabled = false , version = "1.0" , include_apis = false , retention_policy_days = 1 ,}
						hour_metrics = { enabled = false , version = "1.0" , include_apis = false ,   retention_policy_days = 1 ,} 
					} `,
				"static_website": `{ index_document = "index.html" , error_404_document = "404NotFound.html", }`,
				"network_rules": `{ 
					default_action = "Deny", 
					bypass = ["AzureServices"], 
					ip_rules = ["102.12.11.1"], 
					core_services = ["jenkins_ca"], 
				}`,
				"environment_variables": `{ environment = "My-Env" ,  cost_center = "0000" , }`,
				"role_assignments":      `{ Owner = [ { user_name = "svcdcls2@core.com" , principal_id = "c01aaeed-f27f-4ec0-8976-abdadfc20ee7" , skip_aad_check = false}] }`,
				"custom_tags":           `{ tag1  = "vtag1" }`,
				"diagnostic_settings": `[{
						name = "diagnotic_storage_account"
						target_types = ["storage"]
						logs = [{
							category = "StorageRead"
							enabled  = true
							retention_policy = {
								days    = 1
								enabled = true
							}
						}]    
						storage_account = {
							name                = "nonprodunittestsa"  
							resource_group_name = "unit-testing"              
						}
					}]`,
				"tables":    `[{name = "tab2", acl= [{id = "tabaclId21", access_policy = { permissions = "raud", start = "2020-12-02T09:38:21.0000000Z" , expiry = "2021-07-02T10:38:21.0000000Z" }}] } ] `,
				"queues":    `[{ name = "queue1", metadata = { metaqueue1 = "metaqueueV"}, acl = [{ id = "queueaclId21" , access_policy = {permissions = "raud" , start= "2020-12-02T09:38:21.0000000Z" , expiry= "2021-07-02T10:38:21.0000000Z" }}]}]`,
				"adls_gen2": `[{name = "gen2cont2" , properties = { prop1 = "valuepropgen2"} , ace = [{ scope = "default" , type = "user" , id =  null , permissions = "rwx" }] }]`,
				"shares":    `[{name =  "share1" , quota =  "1" , metadata = {metak1 = "metav1"}, directories = [{ metadata = {metak1dir = "metav1dir"} , name = ["share1dir1" , "share1dir2" ]}], acl = [{ id = "aclId11" , access_policy = { permissions = "rwdl" , start = "2020-12-02T09:38:21.0000000Z" , expiry = "2021-07-02T10:38:21.0000000Z" }}]}]`,
				"containers": `[{
						name =  "cont1"          
						metadata =  { metak1 = "metav1" }                
						inventory_policy_rules = [ { name = "inventory_rule_1", format = "Csv", schedule = "Weekly", scope = "Blob", schema_fields = [], filter = { blob_types = ["blockBlob"], include_blob_versions = true, include_snapshots = true, prefix_match = ["*/example"] } } ]
						blobs = [{name =  "blob1" , type =  "Block", size =  "512", access_tier = "Hot" ,content_type = "application/octet-stream" ,source_content = " This is the content of the blob "}  ]
					}]`,
			},
		},
	}
	result := helper.ValidateInitAndPlan(t, helperOptions)

	result.AssertAddedItems(t, 12)
	result.AssertResourceExists(t, "azurerm_storage_account", "storage_account")
	result.AssertBlockParameterEquals(t, "azurerm_storage_account", "storage_account", "tags", "module_name", "storage_account")
	result.AssertResourceExists(t, "azurerm_storage_blob", "blob_storage[blob1]")
	result.AssertResourceExists(t, "azurerm_storage_blob_inventory_policy", "blob_inventory_policy[cont1]")
	result.AssertResourceExists(t, "azurerm_storage_container", "blob_container[cont1]")
	result.AssertResourceExists(t, "azurerm_storage_data_lake_gen2_filesystem", "gen2_filesystem[gen2cont2]")
	result.AssertResourceExists(t, "azurerm_storage_queue", "storage_queue[queue1]")
	result.AssertResourceExists(t, "azurerm_storage_share", "storage_share[share1]")
	result.AssertResourceExists(t, "azurerm_storage_share_directory", "storage_share_directory[share1dir1]")
	result.AssertResourceExists(t, "azurerm_storage_share_directory", "storage_share_directory[share1dir2]")
	result.AssertResourceExists(t, "azurerm_storage_table", "storage_table[tab2]")
	result.AssertResourceExists(t, "module.role_assignments[account_nonprodunittestsa]", "azurerm_role_assignment.role_assignment[Owner_svcdcls2@core.com]")
	result.AssertResourceExists(t, "module.storage_monitor_diagnostic[storage]", "azurerm_monitor_diagnostic_setting.monitor_diagnostic_settings[diagnotic_storage_account-storage]")
}

func Test_Example_StorageAccount_minimal(t *testing.T) {
	// Configure Terraform helper;
	helperOptions := &helper.Options{
		TerraformOptions: &terraform.Options{
			TerraformDir: "../../storage_account_minimal",
		},
	}
	result := helper.ValidateInitAndPlan(t, helperOptions)

	result.AssertAddedItems(t, 2)
	result.AssertResourceExists(t, "module.example_rg.azurerm_resource_group", "resource_group")
	result.AssertResourceExists(t, "module.example_storage.azurerm_storage_account", "storage_account")
}

func Test_Example_StorageAccount_blob(t *testing.T) {
	// Configure Terraform helper;
	helperOptions := &helper.Options{
		TerraformOptions: &terraform.Options{
			TerraformDir: "../../storage_account_blob",
		},
	}
	result := helper.ValidateInitAndPlan(t, helperOptions)

	result.AssertAddedItems(t, 15)
	result.AssertResourceExists(t, "module.example_rg.azurerm_resource_group", "resource_group")
	result.AssertResourceExists(t, "module.example_storage.azurerm_storage_account", "storage_account")
	result.AssertResourceExists(t, "module.example_storage.azurerm_storage_blob", "blob_storage[blob1]")
	result.AssertResourceExists(t, "module.example_storage.azurerm_storage_blob", "blob_storage[blob21]")
	result.AssertResourceExists(t, "module.example_storage.azurerm_storage_blob", "blob_storage[blob22]")
	result.AssertResourceExists(t, "module.example_storage.azurerm_storage_container", "blob_container[cont1]")
	result.AssertResourceExists(t, "module.example_storage.azurerm_storage_container", "blob_container[cont2]")
	result.AssertResourceExists(t, "module.example_storage.module.role_assignments[blob_cont1-blob1]", "azurerm_role_assignment.role_assignment[DevTest Labs User_acl_stdlf_Access]")
	result.AssertResourceExists(t, "module.example_storage.module.role_assignments[blob_cont1-blob1]", "azurerm_role_assignment.role_assignment[DevTest Labs User_svcdcls5@core.com]")
	result.AssertResourceExists(t, "module.example_storage.module.role_assignments[blob_cont1-blob1]", "azurerm_role_assignment.role_assignment[Log Analytics Contributor_benalno@core.com]")
	result.AssertResourceExists(t, "module.example_storage.module.role_assignments[container_cont1]", "azurerm_role_assignment.role_assignment[Backup Operator_Apigee]")
	result.AssertResourceExists(t, "module.example_storage.module.role_assignments[container_cont1]", "azurerm_role_assignment.role_assignment[Backup Operator_benalno@core.com]")
	result.AssertResourceExists(t, "module.example_storage.module.role_assignments[container_cont1]", "azurerm_role_assignment.role_assignment[Backup Operator_svcdcls2@core.com]")
	result.AssertResourceExists(t, "module.example_storage.module.role_assignments[container_cont1]", "azurerm_role_assignment.role_assignment[Reader_acl_stdlf_Access]")
	result.AssertResourceExists(t, "module.example_storage.module.role_assignments[container_cont1]", "azurerm_role_assignment.role_assignment[Reader_svcdcls2@core.com]")

}

func Test_Example_StorageAccount_share(t *testing.T) {
	// Configure Terraform helper;
	helperOptions := &helper.Options{
		TerraformOptions: &terraform.Options{
			TerraformDir: "../../storage_account_share",
		},
	}
	result := helper.ValidateInitAndPlan(t, helperOptions)

	result.AssertAddedItems(t, 10)
	result.AssertResourceExists(t, "module.example_rg.azurerm_resource_group", "resource_group")
	result.AssertResourceExists(t, "module.example_storage.azurerm_storage_account", "storage_account")
	result.AssertResourceExists(t, "module.example_storage.azurerm_storage_share", "storage_share[share1]")
	result.AssertResourceExists(t, "module.example_storage.azurerm_storage_share", "storage_share[share2]")
	result.AssertResourceExists(t, "module.example_storage.azurerm_storage_share_directory", "storage_share_directory[share1dir1]")
	result.AssertResourceExists(t, "module.example_storage.azurerm_storage_share_directory", "storage_share_directory[share1dir2]")
	result.AssertResourceExists(t, "module.example_storage.azurerm_storage_share_directory", "storage_share_directory[share2dir1]")
	result.AssertResourceExists(t, "module.example_storage.module.role_assignments[directory_share1-share1dir1]", "azurerm_role_assignment.role_assignment[Owner_svcdcls4@core.com]")
	result.AssertResourceExists(t, "module.example_storage.module.role_assignments[directory_share1-share1dir2]", "azurerm_role_assignment.role_assignment[Owner_svcdcls4@core.com]")
	result.AssertResourceExists(t, "module.example_storage.module.role_assignments[share_share1]", "azurerm_role_assignment.role_assignment[Log Analytics Reader_svcdcls4@core.com]")

}

func Test_Example_StorageAccount_queue(t *testing.T) {
	// Configure Terraform helper;
	helperOptions := &helper.Options{
		TerraformOptions: &terraform.Options{
			TerraformDir: "../../storage_account_queue",
		},
	}
	result := helper.ValidateInitAndPlan(t, helperOptions)

	result.AssertAddedItems(t, 5)

	result.AssertResourceExists(t, "module.example_rg.azurerm_resource_group", "resource_group")
	result.AssertResourceExists(t, "module.example_storage.azurerm_storage_account", "storage_account")
	result.AssertResourceExists(t, "module.example_storage.azurerm_storage_queue", "storage_queue[queue1]")
	result.AssertResourceExists(t, "module.example_storage.azurerm_storage_queue", "storage_queue[queue2]")
	result.AssertResourceExists(t, "module.example_storage.module.role_assignments[queue_queue1]", "azurerm_role_assignment.role_assignment[Monitoring Reader_svcdcls4@core.com]")
}

func Test_Example_StorageAccount_table(t *testing.T) {
	// Configure Terraform helper;
	helperOptions := &helper.Options{
		TerraformOptions: &terraform.Options{
			TerraformDir: "../../storage_account_table",
		},
	}
	result := helper.ValidateInitAndPlan(t, helperOptions)

	result.AssertAddedItems(t, 5)
	result.AssertResourceExists(t, "module.example_rg.azurerm_resource_group", "resource_group")
	result.AssertResourceExists(t, "module.example_storage.azurerm_storage_account", "storage_account")
	result.AssertResourceExists(t, "module.example_storage.azurerm_storage_table", "storage_table[tab1]")
	result.AssertResourceExists(t, "module.example_storage.azurerm_storage_table", "storage_table[tab2]")
	result.AssertResourceExists(t, "module.example_storage.module.role_assignments[table_tab1]", "azurerm_role_assignment.role_assignment[Logic App Contributor_svcdcls4@core.com]")

}

func Test_Example_StorageAccount_Encryption(t *testing.T) {
	// Configure Terraform helper;
	helperOptions := &helper.Options{
		TerraformOptions: &terraform.Options{
			TerraformDir: "../../storage_account_encryption",
		},
	}
	result := helper.ValidateInitAndPlan(t, helperOptions)

	result.AssertAddedItems(t, 5)
	result.AssertResourceExists(t, "module.example_rg.azurerm_resource_group", "resource_group")
	result.AssertResourceExists(t, "module.example_storage.azurerm_storage_account", "storage_account")
	result.AssertResourceExists(t, "module.example_storage.azurerm_storage_account_customer_managed_key", "storage_encryption[0]")
	result.AssertResourceExists(t, "module.key_vault_module.azurerm_key_vault", "key_vault")
	//result.AssertResourceExists(t, "module.key_vault_module.azurerm_key_vault_key", "kv_key[mymodrole5-k-str]")
}

func Test_Example_StorageAccount_rbac(t *testing.T) {
	// Configure Terraform helper;
	helperOptions := &helper.Options{
		TerraformOptions: &terraform.Options{
			TerraformDir: "../../storage_account_rbac",
		},
	}
	result := helper.ValidateInitAndPlan(t, helperOptions)

	result.AssertAddedItems(t, 10)

	result.AssertResourceExists(t, "module.example_rg.azurerm_resource_group", "resource_group")
	result.AssertResourceExists(t, "module.example_storage.azurerm_storage_account", "storage_account")
	result.AssertResourceExists(t, "module.example_storage.azurerm_storage_share", "storage_share[share1]")
	result.AssertResourceExists(t, "module.example_storage.azurerm_storage_sync", "storage_sync[share1]")
	result.AssertBlockParameterEquals(t, "module.example_storage.azurerm_storage_sync", "storage_sync[share1]", "tags", "module_name", "storage_account")
	result.AssertResourceExists(t, "module.example_storage.azurerm_storage_sync_cloud_endpoint", "sync_cloud_endpoint[share1]")
	result.AssertResourceExists(t, "module.example_storage.azurerm_storage_sync_group", "sync_group[share1]")
	result.AssertResourceExists(t, "module.example_storage.module.role_assignments[account_storageacntrbac]", "azurerm_role_assignment.role_assignment[Contributor_svcdcls2@core.com]")
	result.AssertResourceExists(t, "module.example_storage.module.role_assignments[account_storageacntrbac]", "azurerm_role_assignment.role_assignment[Reader and Data Access_Microsoft.StorageSync]")
	result.AssertResourceExists(t, "module.example_storage.module.role_assignments[account_storageacntrbac]", "azurerm_role_assignment.role_assignment[Reader and Data Access_svcdcls2@core.com]")
	result.AssertResourceExists(t, "module.example_storage.module.role_assignments[share_share1]", "azurerm_role_assignment.role_assignment[Log Analytics Reader_svcdcls4@core.com]")

}

func Test_Example_StorageAccount_lifecycle(t *testing.T) {
	// Configure Terraform helper;
	helperOptions := &helper.Options{
		TerraformOptions: &terraform.Options{
			TerraformDir: "../../storage_account_lifecycle",
		},
	}
	result := helper.ValidateInitAndPlan(t, helperOptions)

	result.AssertAddedItems(t, 16)
	result.AssertResourceExists(t, "module.example_rg.azurerm_resource_group", "resource_group")
	result.AssertResourceExists(t, "module.example_storage.azurerm_storage_account", "storage_account")
	result.AssertResourceExists(t, "module.example_storage.azurerm_storage_blob", "blob_storage[blob1]")
	result.AssertResourceExists(t, "module.example_storage.azurerm_storage_blob", "blob_storage[blob21]")
	result.AssertResourceExists(t, "module.example_storage.azurerm_storage_blob", "blob_storage[blob22]")
	result.AssertResourceExists(t, "module.example_storage.azurerm_storage_container", "blob_container[cont1]")
	result.AssertResourceExists(t, "module.example_storage.azurerm_storage_container", "blob_container[cont2]")
	result.AssertResourceExists(t, "module.example_storage.azurerm_storage_management_policy", "management_policy[0]")
	result.AssertBlockParameterEquals(t, "module.example_storage.azurerm_storage_management_policy", "management_policy[0]", "rule", "name", "rule3")
	result.AssertBlockParameterEquals(t, "module.example_storage.azurerm_storage_management_policy", "management_policy[0]", "rule", "enabled", "true")
}

func Test_Example_StorageAccount_private_endpoint(t *testing.T) {
	// Configure Terraform helper;
	helperOptions := &helper.Options{
		TerraformOptions: &terraform.Options{
			TerraformDir: "../../storage_account_private_endpoint",
		},
	}
	result := helper.ValidateInitAndPlan(t, helperOptions)

	result.AssertAddedItems(t, 11)
	result.AssertResourceExists(t, "module.storage_account.azurerm_storage_account", "storage_account")
	result.AssertResourceExists(t, "module.resource_group.azurerm_resource_group", "resource_group")
	result.AssertResourceExists(t, "module.storage_account.azurerm_storage_table", "storage_table[tab1]")
	result.AssertResourceExists(t, "module.storage_account.azurerm_storage_table", "storage_table[tab2]")
	result.AssertResourceExists(t, "module.storage_account.module.private_endpoint[unittest01cacst-blob-endpoint].azurerm_private_endpoint", "endpoint")
	result.AssertResourceExists(t, "module.storage_account.module.private_endpoint[unittest01cacst-table-endpoint].azurerm_private_endpoint", "endpoint")
	result.AssertResourceExists(t, "module.storage_account.module.private_endpoint[unittest01cacst-queue-endpoint].azurerm_private_endpoint", "endpoint")
	result.AssertResourceExists(t, "module.storage_account.module.private_endpoint[unittest01cacst-file-endpoint].azurerm_private_endpoint", "endpoint")
	result.AssertResourceExists(t, "module.storage_account.module.private_endpoint[unittest01cacst-dfs-endpoint].azurerm_private_endpoint", "endpoint")
	result.AssertResourceExists(t, "module.storage_account.module.private_endpoint[unittest01cacst-web-endpoint].azurerm_private_endpoint", "endpoint")
	result.AssertResourceExists(t, "module.storage_account.module.role_assignments[table_tab1].azurerm_role_assignment", "role_assignment[Logic App Contributor_svcdcls4@core.com]")
	result.AssertBlockParameterEquals(t, "module.storage_account.module.private_endpoint[unittest01cacst-web-endpoint].azurerm_private_endpoint", "endpoint", "private_service_connection", "name", "unittest01cacst-web-private-service")
	result.AssertBlockParameterEquals(t, "module.storage_account.module.private_endpoint[unittest01cacst-table-endpoint].azurerm_private_endpoint", "endpoint", "private_service_connection", "name", "unittest01cacst-table-private-service")
	result.AssertBlockParameterEquals(t, "module.storage_account.module.private_endpoint[unittest01cacst-file-endpoint].azurerm_private_endpoint", "endpoint", "private_service_connection", "name", "unittest01cacst-file-private-service")
	result.AssertBlockParameterEquals(t, "module.storage_account.module.private_endpoint[unittest01cacst-queue-endpoint].azurerm_private_endpoint", "endpoint", "private_service_connection", "name", "unittest01cacst-queue-private-service")
	result.AssertBlockParameterEquals(t, "module.storage_account.module.private_endpoint[unittest01cacst-dfs-endpoint].azurerm_private_endpoint", "endpoint", "private_service_connection", "name", "unittest01cacst-dfs-private-service")
	result.AssertBlockParameterEquals(t, "module.storage_account.module.private_endpoint[unittest01cacst-blob-endpoint].azurerm_private_endpoint", "endpoint", "private_service_connection", "name", "unittest01cacst-blob-private-service")
}

func Test_Example_StorageAccount_All(t *testing.T) {
	helperOptions := &helper.Options{
		TerraformOptions: &terraform.Options{
			TerraformDir: "../../storage_account_all",
		},
	}
	result := helper.ValidateInitAndPlan(t, helperOptions)

	result.AssertAddedItems(t, 35)
	result.AssertResourceExists(t, "module.example_rg.azurerm_resource_group", "resource_group")
	result.AssertResourceExists(t, "module.example_storage.azurerm_storage_account", "storage_account")
	result.AssertResourceExists(t, "module.example_storage.azurerm_storage_blob", "blob_storage[blob1]")
	result.AssertResourceExists(t, "module.example_storage.azurerm_storage_blob", "blob_storage[blob21]")
	result.AssertResourceExists(t, "module.example_storage.azurerm_storage_blob_inventory_policy", "blob_inventory_policy[cont1]")
	result.AssertResourceExists(t, "module.example_storage.azurerm_storage_container", "blob_container[cont1]")
	result.AssertResourceExists(t, "module.example_storage.azurerm_storage_container", "blob_container[cont2]")
	result.AssertResourceExists(t, "module.example_storage.azurerm_storage_queue", "storage_queue[queue1]")
	result.AssertResourceExists(t, "module.example_storage.azurerm_storage_queue", "storage_queue[queue2]")
	result.AssertResourceExists(t, "module.example_storage.azurerm_storage_share", "storage_share[share-one]")
	result.AssertResourceExists(t, "module.example_storage.azurerm_storage_share", "storage_share[share-two]")
	result.AssertResourceExists(t, "module.example_storage.azurerm_storage_share_directory", "storage_share_directory[share1dir1]")
	result.AssertResourceExists(t, "module.example_storage.azurerm_storage_share_directory", "storage_share_directory[share1dir2]")
	result.AssertResourceExists(t, "module.example_storage.azurerm_storage_share_directory", "storage_share_directory[share2dir1]")
	result.AssertResourceExists(t, "module.example_storage.azurerm_storage_table", "storage_table[tab1]")
	result.AssertResourceExists(t, "module.example_storage.azurerm_storage_table", "storage_table[tab2]")
	result.AssertResourceExists(t, "module.example_storage.module.role_assignments[account_examplestorageacnt].azurerm_role_assignment", "role_assignment[Contributor_Apigee]")
	result.AssertResourceExists(t, "module.example_storage.module.role_assignments[account_examplestorageacnt].azurerm_role_assignment", "role_assignment[Contributor_svcdcls2@core.com]")
	result.AssertResourceExists(t, "module.example_storage.module.role_assignments[account_examplestorageacnt].azurerm_role_assignment", "role_assignment[Owner_svcdcls2@core.com]")
	result.AssertResourceExists(t, "module.example_storage.module.role_assignments[container_cont1].azurerm_role_assignment", "role_assignment[Backup Operator_Apigee]")
	result.AssertResourceExists(t, "module.example_storage.module.role_assignments[container_cont1].azurerm_role_assignment", "role_assignment[Backup Operator_svcdcls2@core.com]")
	result.AssertResourceExists(t, "module.example_storage.module.role_assignments[container_cont1].azurerm_role_assignment", "role_assignment[Reader_acl_stdlf_Access]")
	result.AssertResourceExists(t, "module.example_storage.module.role_assignments[container_cont1].azurerm_role_assignment", "role_assignment[Reader_svcdcls2@core.com]")
	result.AssertResourceExists(t, "module.example_storage.module.role_assignments[container_cont2].azurerm_role_assignment", "role_assignment[DevTest Labs User_acl_stdlf_Access]")
	result.AssertResourceExists(t, "module.example_storage.module.role_assignments[container_cont2].azurerm_role_assignment", "role_assignment[DevTest Labs User_svcdcls5@core.com]")
	result.AssertResourceExists(t, "module.example_storage.module.role_assignments[container_cont2].azurerm_role_assignment", "role_assignment[Log Analytics Contributor_benalno@core.com]")
	result.AssertResourceExists(t, "module.example_storage.module.role_assignments[directory_share-one-share1dir1].azurerm_role_assignment", "role_assignment[Owner_svcdcls4@core.com]")
	result.AssertResourceExists(t, "module.example_storage.module.role_assignments[directory_share-one-share1dir2].azurerm_role_assignment", "role_assignment[Owner_svcdcls4@core.com]")
	result.AssertResourceExists(t, "module.example_storage.module.role_assignments[queue_queue1].azurerm_role_assignment", "role_assignment[Monitoring Reader_svcdcls4@core.com]")
	result.AssertResourceExists(t, "module.example_storage.module.role_assignments[share_share-one].azurerm_role_assignment", "role_assignment[Log Analytics Reader_svcdcls4@core.com]")
	result.AssertResourceExists(t, "module.example_storage.module.role_assignments[table_tab1].azurerm_role_assignment", "role_assignment[Logic App Contributor_svcdcls4@core.com]")
	result.AssertResourceExists(t, "module.example_storage.module.storage_monitor_diagnostic[blob].azurerm_monitor_diagnostic_setting", "monitor_diagnostic_settings[diagnostic_storage_account2-blob]")
	result.AssertResourceExists(t, "module.example_storage.module.storage_monitor_diagnostic[file].azurerm_monitor_diagnostic_setting", "monitor_diagnostic_settings[diagnostic_storage_account-file]")
	result.AssertResourceExists(t, "module.example_storage.module.storage_monitor_diagnostic[file].azurerm_monitor_diagnostic_setting", "monitor_diagnostic_settings[diagnostic_storage_account2-file]")
	result.AssertResourceExists(t, "module.example_storage.module.storage_monitor_diagnostic[storage].azurerm_monitor_diagnostic_setting", "monitor_diagnostic_settings[diagnostic_storage_account-storage]")
}

func Test_Example_StorageAccount_blob_inventory(t *testing.T) {
	helperOptions := &helper.Options{
		TerraformOptions: &terraform.Options{
			TerraformDir: "../../storage_account_blob_inventory",
		},
	}
	result := helper.ValidateInitAndPlan(t, helperOptions)

	result.AssertAddedItems(t, 5)
	result.AssertResourceExists(t, "module.example_rg.azurerm_resource_group", "resource_group")
	result.AssertResourceExists(t, "module.example_storage.azurerm_storage_account", "storage_account")
	result.AssertResourceExists(t, "module.example_storage.azurerm_storage_blob_inventory_policy", "blob_inventory_policy[cont1]")
	result.AssertResourceExists(t, "module.example_storage.azurerm_storage_container", "blob_container[cont1]")
	result.AssertResourceExists(t, "module.example_storage.module.role_assignments[container_cont1]", "azurerm_role_assignment.role_assignment[Reader_svcdcls2@core.com]")
}

func Test_Example_StorageAccount_monitor_diagnostic(t *testing.T) {
	helperOptions := &helper.Options{
		TerraformOptions: &terraform.Options{
			TerraformDir: "../../storage_account_monitor_diagnostic",
		},
	}
	result := helper.ValidateInitAndPlan(t, helperOptions)

	result.AssertAddedItems(t, 6)
	result.AssertResourceExists(t, "module.example_storage.azurerm_storage_account", "storage_account")
	result.AssertResourceExists(t, "module.example_storage.module.storage_monitor_diagnostic[blob]", "azurerm_monitor_diagnostic_setting.monitor_diagnostic_settings[diagnotic_storage_account2-blob]")
	result.AssertResourceExists(t, "module.example_storage.module.storage_monitor_diagnostic[file]", "azurerm_monitor_diagnostic_setting.monitor_diagnostic_settings[diagnostic_storage_account-file]")
	result.AssertResourceExists(t, "module.example_rg.azurerm_resource_group", "resource_group")
	result.AssertResourceExists(t, "module.example_storage.module.storage_monitor_diagnostic[storage]", "azurerm_monitor_diagnostic_setting.monitor_diagnostic_settings[diagnostic_storage_account-storage]")
	result.AssertResourceExists(t, "module.example_storage.module.storage_monitor_diagnostic[table]", "azurerm_monitor_diagnostic_setting.monitor_diagnostic_settings[diagnotic_storage_account2-table]")
}
