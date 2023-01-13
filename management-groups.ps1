<#
.SYNOPSIS
    Script to create Azure Management Groups.
.DESCRIPTION
    This script will create Azure Management Groups. 
    The outcome is based on a best practice approach.
.COMPONENT
    The following Azure services will be used to reach the targeted state:
    - Azure Management Groups
.NOTES
    Author...............: Pascal Plaga
        Github...........: https://github.com/psclplg 
        LinkedIn.........: https://www.linkedin.com/in/pascalplaga
    Version..............: 0.1
    TBD..................: ---
    Issues...............: - There is an open issue on GitHub for the cmdlet.
                             The management groups will be created but the command ends with an error. 
                             https://github.com/Azure/azure-powershell/issues/16704
                             Therefore the ErrorAction SilentlyContinue.
                           - The parameter 'GroupName' will be replaced by 'GroupId' in future Az PowerShell releases
#>

If (!(Get-AzAccessToken)) {
    Connect-AzAccount
}

$companyShortName  = "COMP"
$workload = "YOUR_WORKLOAD"                                                                 # substitute the placeholder to match your requirements or leave blank to skip
$sandbox = "YOUR_TEAM_DEPARTMENT_ETC"                                                       # substitute the placeholder to match your requirements or leave blank to skip

$mgintroot = "mg-$($customershort)-int-root"
$mgbaseline = "mg-platform","mg-workloads","mg-sandbox"
$mgplatform = "mg-platform-connectivity","mg-platform-identity","mg-platform-mgmt"
$mgworkloads = "mg-workloads-$($workload)"                                                  # you can add multiple values as it will be processed with a loop
$mgsandbox = "mg-sandbox-$($sandbox)"                                                       # you can add multiple values as it will be processed with a loop

New-AzManagementGroup -GroupName $mgintroot -DisplayName $mgintroot

foreach ($mg in $mgbaseline) {
    New-AzManagementGroup -GroupName $mg -DisplayName $mg -ParentId /providers/Microsoft.Management/managementGroups/$($introot) -ErrorAction SilentlyContinue
}

foreach ($mg in $mgplatform) {
    New-AzManagementGroup -GroupName $mg -DisplayName $mg -ParentId /providers/Microsoft.Management/managementGroups/mg-platform -ErrorAction SilentlyContinue
}

if ($workload) {
    foreach ($mg in $mgworkloads) {
        New-AzManagementGroup -GroupName $mg -DisplayName $mg -ParentId /providers/Microsoft.Management/managementGroups/mg-workloads -ErrorAction SilentlyContinue
    }
}

if ($sandbox) {
    foreach ($mg in $mgsandbox) {
        New-AzManagementGroup -GroupName $mg -DisplayName $mg -ParentId /providers/Microsoft.Management/managementGroups/mg-sandbox -ErrorAction SilentlyContinue
    }
}
