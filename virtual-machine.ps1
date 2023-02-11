<#
.SYNOPSIS
    Script to create Virtual Machines and associated resources.
.DESCRIPTION
    This script will create virtual machine resources in a geo-location of your choice. 
.COMPONENT
    The following Azure services will be used to reach the targeted state:
    - Azure Resource Groups
    - Azure Locations
    - Azure Virtual Networks
    - Azure Virtual Machines
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

$password = "SuperSecureP@$$w0rd"           # <--- REPLACE this passowrd with your own, make it a prompt or make use of a key vault

$VMLocalAdminUser = "vm-admin"
$VMLocalAdminSecurePassword = ConvertTo-SecureString $password -AsPlainText -Force
$LocationName = "westeurope"
$ResourceGroupName = "rg-vm"
$VMName = "vmweuwin01"
$VMSize = "Standard_B2s"

$NetworkName = "vnet-spoke1"
$NICName = "nic-$($VMName)"

$Vnet = Get-AzVirtualNetwork -Name $NetworkName
$NIC = New-AzNetworkInterface -Name $NICName -ResourceGroupName $ResourceGroupName -Location $LocationName -SubnetId $Vnet.Subnets[0].Id

$Credential = New-Object System.Management.Automation.PSCredential ($VMLocalAdminUser, $VMLocalAdminSecurePassword);

$VirtualMachine = New-AzVMConfig -VMName $VMName -VMSize $VMSize
$VirtualMachine = Set-AzVMOperatingSystem -VM $VirtualMachine -Windows -ComputerName $VMName -Credential $Credential -ProvisionVMAgent -EnableAutoUpdate:$False -PatchMode Manual
$VirtualMachine = Add-AzVMNetworkInterface -VM $VirtualMachine -Id $NIC.Id
$VirtualMachine = Set-AzVMBootDiagnostic -VM $VirtualMachine -Enable
$VirtualMachine = Set-AzVMSourceImage -VM $VirtualMachine -PublisherName 'MicrosoftWindowsServer' -Offer 'WindowsServer' -Skus '2022-datacenter-azure-edition-smalldisk' -Version latest

New-AzVM -ResourceGroupName $ResourceGroupName -Location $LocationName -VM $VirtualMachine -Verbose