$domain = Read-Host "Enter domain to look up"
$tenantInfo = Invoke-WebRequest -Method Get -Uri https://login.microsoftonline.com/$($domain)/.well-known/openid-configuration -SkipHttpErrorCheck | ConvertFrom-Json
if (!($tenantInfo.error -eq "invalid_tenant")) {
    $tenantId = $tenantInfo.issuer.Split("/")[3]
    $tenantRegion = $tenantInfo.tenant_region_scope
    Write-Host ""
    Write-Host "Microsoft tenant information for '$($domain)':" -ForegroundColor Yellow
    Write-Host "Tenant ID: $($tenantId)" -ForegroundColor Green
    Write-Host "Tenant Region: $($tenantRegion)" -ForegroundColor Green
    Write-Host ""
}
else {
    Write-Host ""
    Write-Host "Non existent tenant for domain '$($domain)'" -ForegroundColor Red
    Write-Host ""
}