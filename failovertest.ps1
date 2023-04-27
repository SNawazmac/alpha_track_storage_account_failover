param(
[Parameter(Mandatory=$true)][string]$storage_account_resource_group_name,       #Enter the resourcegroup name of the Storageaccount
[Parameter(Mandatory=$true)][array]$private_storage_account_names,            #Enter the storage account name(s) on which failover has to be initiated
[Parameter(Mandatory=$true)][string]$sku                                    #Enter the SKU as Standard_GRS to re-enable geo-replication post failover
[Parameter(Mandatory=$true)][string]$primary_region_subscription_id       
)

Set-AzContext -Subscription $primary_region_subscription_id

$storage_accounts = $private_storage_account_names.split(",")
foreach($storage_account_name in $storage_accounts)
{
#Below command Invokes failover on the selected storage account(s)
$failover = Invoke-AzStorageAccountFailover -ResourceGroupName $storage_account_resource_group_name -Name $storage_account_name -Force -AsJob
}

Wait-Job $failover

foreach($storage_account_name in $storage_accounts)
{
#Below command updates the SKU of the storage account(s) to Standard_GRS post failover
Set-AzStorageAccount -ResourceGroupName $storage_account_resource_group_name -Name $storage_account_name -SkuName $sku -Force
}
