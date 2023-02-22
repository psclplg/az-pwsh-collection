<#
.SYNOPSIS
    Script to create custom role Virtual Machines Operator.
.DESCRIPTION
    This script will create a custom role for Virtual Machine Operator 
    and allows to start, restart and deallocate virtual machines. 
.COMPONENT
    The following Azure services will be used to reach the targeted state:
    - Azure Subscriptions
    - Azure Custom Roles
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

$subscription = (Get-AzContext).Subscription.Id

$role = Get-AzRoleDefinition -Name "Virtual Machine Contributor"

$role.Id = $null
$role.Name = "Virtual Machine Operator"
$role.Description = "Can start, restart and deallocate virtual machines."
$role.IsCustom = $true
$role.Actions.RemoveRange(0,$role.Actions.Count)
$role.Actions.Add("Microsoft.Compute/*/read")
$role.Actions.Add("Microsoft.Compute/virtualMachines/start/action")
$role.Actions.Add("Microsoft.Compute/virtualMachines/restart/action")
$role.Actions.Add("Microsoft.Compute/virtualMachines/deallocate/action")
$role.Actions.Add("Microsoft.Network/*/read")
$role.Actions.Add("Microsoft.Storage/*/read")
$role.Actions.Add("Microsoft.Authorization/*/read")
$role.Actions.Add("Microsoft.Resources/subscriptions/resourceGroups/read")
$role.Actions.Add("Microsoft.Resources/subscriptions/resourceGroups/resources/read")
$role.AssignableScopes.Clear()
$role.AssignableScopes.Add("/subscriptions/$($subscription)")

New-AzRoleDefinition -Role $role