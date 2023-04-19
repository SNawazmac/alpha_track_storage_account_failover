param(
[Parameter(Mandatory=$true)][string]$primary_subscription_Id,           #Enter the primary subscription Id of private DNS zone
[Parameter(Mandatory=$true)][string]$secondary_private_endpoint_subscription_Id,         #Enter the secondary subscription Id of secondary private endpoint
[Parameter(Mandatory=$true)][string]$secondary_private_endpoint_resource_group_name,     #Enter the secondary resourcegroup name where the secondary private endpoint is existing           
[Parameter(Mandatory=$true)][string]$secondary_private_endpoint_name,   #Enter the secondary private endpoint name
[Parameter(Mandatory=$true)][string]$storage_account_private_dns_zone_name,                         #Enter the name of the existing Private DNS Zone
[Parameter(Mandatory=$true)][string]$storage_account_private_dns_zone_group_name,       #Enter the name of the existing Private DNS Zone group
[Parameter(Mandatory=$true)][string]$private_dns_zone_resource_group_name
)

#The below command sets authentication information for cmdlets that run in the current session
Set-AzContext -Subscription $primary_subscription_Id

#The below commands fetches the existing Private DNS Zone information to be linked
$Zone = Get-AzPrivateDnsZone -ResourceGroupName $private_dns_zone_resource_group_name -Name $storage_account_private_dns_zone_name
$PrivateDnsZoneId = $zone.ResourceId

#The below commands creates config for private DNS zone integration
$config = New-AzPrivateDnsZoneConfig -Name $storage_account_private_dns_zone_name -PrivateDnsZoneId $PrivateDnsZoneId

#The below command sets authentication information for cmdlets that run in the current session
Set-AzContext -Subscription $secondary_private_endpoint_subscription_Id

#The below command links the secondary private endpoint to the existing Private DNS zone
Set-AzPrivateDnsZoneGroup -ResourceGroupName $secondary_private_endpoint_resource_group_name -PrivateEndpointName $secondary_private_endpoint_name -Name $private_dns_zone_resource_group_name -PrivateDnsZoneConfig $config  

