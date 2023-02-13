<#
.SYNOPSIS
    Script to check availability of Microsoft Cloud PowerShell modules.
.DESCRIPTION
    This script will check if PowerShell modules Az and Microsoft.Graph are installed.
    If the modules turn out to be missing the script offers to install them within scope for the current user. 
.COMPONENT
    The following services/resources will be used to reach the targeted state:
    - PowerShell (tested with version 7.x)
    - PSGallery - this is where the modules are hosted
        You can register PSGallery as trusted repository and suppress warnings:
        >_: Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
    - NuGet Package Provider
        Package provider NuGet is required when working with PSGallery:
        >_: Install-PackageProvider -Name NuGet -Force
.NOTES
    Author...............: Pascal Plaga
        Github...........: https://github.com/psclplg 
        LinkedIn.........: https://www.linkedin.com/in/pascalplaga
    Version..............: 0.1
    TBD..................: ---
    Issues...............: ---
#>

$psModuleAz = Get-Module -Name Az -ErrorAction SilentlyContinue
Write-Host ""
Write-Host ""
sleep 1
Write-Host "Checking availability of PowerShell module Az..."
sleep 2
if (!($psModuleAz)) {
    Write-Host ""
    Write-Host "PowerShell module Az is not installed." -ForegroundColor Yellow
    Write-Host "Do you want to install it now?"
    $installAz = Read-Host "[Y]/[N]"
    if ($installAz -eq "Y") {
        try {
            Install-Module -Name Az -Scope CurrentUser -AllowClobber
            Write-Host ""
            Write-Host "PowerShell module Az successfully installed." -ForegroundColor Green
            sleep 1
            Write-Host "Continuing..." -ForegroundColor Green
        }
        catch {
            Write-Host ""
            Write-Host "Error installing PowerShell module Az." -ForegroundColor Red
            Write-Host "Manual checks required." -ForegroundColor Red
        }
    }
}
elseif ($psModuleAz) {
    Write-Host ""
    Write-Host "PowerShell module Az already installed." -ForegroundColor Green
    sleep 1
    Write-Host "Continuing..." -ForegroundColor Green
}
else {
    Write-Host "PowerShell module Az in unknown state."
}

$psModuleMsGraph = Get-Module -Name Microsoft.Graph -ErrorAction SilentlyContinue
Write-Host ""
Write-Host ""
sleep 1
Write-Host "Checking availability of PowerShell module Microsoft.Graph..."
sleep 2
if (!($psModuleMsGraph)) {
    Write-Host ""
    Write-Host "PowerShell module Microsoft.Graph is not installed." -ForegroundColor Yellow
    Write-Host "Do you want to install it now?"
    $installAz = Read-Host "[Y]/[N]"
    if ($installAz -eq "Y") {
        try {
            Install-Module -Name Microsoft.Graph -Scope CurrentUser -AllowClobber
            Write-Host ""
            Write-Host "PowerShell module Microsoft.Graph successfully installed." -ForegroundColor Green
            sleep 1
            Write-Host "Continuing..." -ForegroundColor Green
        }
        catch {
            Write-Host ""
            Write-Host "Error installing PowerShell module Microsoft.Graph." -ForegroundColor Red
            Write-Host "Manual checks required." -ForegroundColor Red
        }
    }
}
elseif ($psModuleMsGraph) {
    Write-Host ""
    Write-Host "PowerShell module Microsoft.Graph already installed." -ForegroundColor Green
    sleep 1
    Write-Host "Continuing..." -ForegroundColor Green
}
else {
    Write-Host "PowerShell module Microsoft.Graph in unknown state."
}

Write-Host ""
Write-Host ""
sleep 1
Write-Host "Evaluating information..."
sleep 2
Write-Host ""
if (($psModuleAz) -and ($psModuleMsGraph)) {
    Write-Host "All requirements towards PowerShell modules are satisfied." -ForegroundColor Green
    Write-Host "You are good to go." -ForegroundColor Green
}
else {
    Write-Host "You need to manually check and satisfy requirements before continuing." -ForegroundColor Yellow
    Write-Host "Sorry, your bad." -ForegroundColor Yellow
}
sleep 1
Write-Host ""