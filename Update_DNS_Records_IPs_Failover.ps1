param(
[Parameter(Mandatory=$true)][string]$private_dns_zone_subscription_Id, #Enter the Subscription Id where the Private dns zone is existing
[Parameter(Mandatory=$true)][string]$private_dns_zone_resource_group_name,     #Enter the resourcegroup name of the Private dns zone
[Parameter(Mandatory=$true)][string]$storage_account_private_dns_zone_name,               #Enter the name of the private dns zone
[Parameter(Mandatory=$true)][string]$storage_account_private_dns_zone_record_name,             #Enter the name of the recordname to be updated
[Parameter(Mandatory=$true)][string]$storage_account_primary_private_endpoint_IP,                   #Enter the new IP to be added
[Parameter(Mandatory=$true)][string]$storage_account_secondary_private_endpoint_IP                    #Enter the old IP to be removed
)

#The below command sets authentication information for cmdlets that run in the current session
Set-AzContext -Subscription $private_dns_zone_subscription_Id

#The below commands adds the new IP to the DNS recordset
$RecordSet = Get-AzPrivateDnsRecordSet -ResourceGroupName $private_dns_zone_resource_group_name -ZoneName $storage_account_private_dns_zone_name -Name $storage_account_private_dns_zone_record_name -RecordType A

Add-AzPrivateDnsRecordConfig -RecordSet $RecordSet -Ipv4Address $storage_account_secondary_private_endpoint_IP
 
Set-AzPrivateDnsRecordSet -RecordSet $RecordSet

#The below commands removes the old IP from the DNS recordset
$RecordSet = Get-AzPrivateDnsRecordSet -Name $storage_account_private_dns_zone_record_name -RecordType A -ResourceGroupName $private_dns_zone_resource_group_name -ZoneName $storage_account_private_dns_zone_name

Remove-AzPrivateDnsRecordConfig -RecordSet $RecordSet -Ipv4Address $storage_account_primary_private_endpoint_IP

Set-AzPrivateDnsRecordSet -RecordSet $RecordSet
