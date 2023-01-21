<#
.SYNOPSIS
    Script to manage Azure subscriptions.
.DESCRIPTION
    This script will let you choose the subscription scope from the available Azure subscriptions. 
.COMPONENT
    The following Azure services will be used to reach the targeted state:
    - Azure subscriptions
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

$subscriptions = Get-AzSubscription
    if ($subscriptions.Count -gt 1) {
        $subEnum = 0
        Write-Host "`nFollowing subscriptions are available:`n"
        foreach ($subscription in $subscriptions) {
            Write-Host "$($subEnum). $($subscription.Name)`t$($subscription.TenantId)"
            $subEnum ++
        }
        $subNumber = Read-Host "`nSelect subscription (by number)"
        $script:subscription = $subscriptions[$subNumber]
        Set-AzContext -Subscription $subscription.SubscriptionId | Out-Null
        Write-Host "`nSelected following subscription:" -ForegroundColor Yellow
        Write-Host "$($subscription.Name) from tenant $($subscription.TenantId)`n" -ForegroundColor Green
        }
    else {
        $script:subscription = $subscriptions
        Set-AzContext -Subscription $subscription.SubscriptionId | Out-Null
        Write-Host "`nSelected following subscription:" -ForegroundColor Yellow
        Write-Host "$($subscription.Name) from tenant $($subscription.TenantId)`n" -ForegroundColor Green   
    }