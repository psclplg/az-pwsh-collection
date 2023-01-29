<#
.SYNOPSIS
    Script to create Resource Groups.
.DESCRIPTION
    This script will create a resource group in a geo-location of your choice. 
.COMPONENT
    The following Azure services will be used to reach the targeted state:
    - Azure Resource Groups
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

# Get a table of available physical locations with this command
# Get-AzLocation | Where-Object {$_.RegionType -eq "Physical"} | ft DisplayName,Location
$location = "westeurope"
$rgs = "rg-network","rg-log","rg-vm","rg-automation"
foreach ($rg in $rgs) {
    New-AzResourceGroup -Name $rg -Location $location
}