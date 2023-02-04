<#
.SYNOPSIS
    Script to create Networking resources.
.DESCRIPTION
    This script will create networking resources in a geo-location of your choice. 
.COMPONENT
    The following Azure services will be used to reach the targeted state:
    - Azure Resource Groups
    - Azure Locations
    - Azure Virtual Networks
.NOTES
    Author...............: Pascal Plaga
        Github...........: https://github.com/psclplg 
        LinkedIn.........: https://www.linkedin.com/in/pascalplaga
    Version..............: 0.1
    TBD..................: ---
    Issues...............: ---
#>

If (!(Get-AzAccessToken)) {
    Connect-AzAccount
}


$segments = "hub","spoke1","spoke2","spoke3"
$i = 10

foreach ($segment in $segments) {
    $snet = New-AzVirtualNetworkSubnetConfig -Name "snet-$($segment)-1" -AddressPrefix "10.10.$($i).0/28"
    New-AzVirtualNetwork -Name "vnet-$($segment)" -ResourceGroupName "rg-network" -Location "westeurope" -AddressPrefix "10.10.$($i).0/24" -Subnet $snet
    $i++
}

$hubNetName = "vnet-hub"
$spokeNetNames = "vnet-spoke1","vnet-spoke2","vnet-spoke3"
$hubNet = Get-AzVirtualNetwork -Name $hubNetName

foreach($spokeNetName in $spokeNetNames) {
    $spokeNet = Get-AzVirtualNetwork -Name $spokeNetName
    Add-AzVirtualNetworkPeering -Name "peer-$($hubNet.Name)_$($spokeNet.Name)" -VirtualNetwork $hubNet -RemoteVirtualNetworkId $spokeNet.Id
    Add-AzVirtualNetworkPeering -Name "peer-$($spokeNet.Name)_$($hubNet.Name)" -VirtualNetwork $spokeNet -RemoteVirtualNetworkId $hubNet.Id -AllowForwardedTraffic
}