#Lists the licenses assigned to a single user.

Import-Module Microsoft.Graph.Authentication
Import-Module Microsoft.Graph.Users

Write-Host "Connecting to MS Graph..." -ForegroundColor Cyan
Connect-MgGraph -Scopes "User.Read.All" -UseDeviceCode
Write-Host "Connected to MS Graph." -ForegroundColor Green

$userInput = Read-Host "Enter the user's email"
Write-Host "Looking up license info for '$userInput'..." -ForegroundColor Cyan

#-ErrorAction Stop is what makes the catch below actually fire. Without it
#Graph raises a non-terminating error and the script sails straight past.
try {
    $user = Get-MgUser -UserId $userInput -Property Id,DisplayName,UserPrincipalName -ErrorAction Stop
} catch {
    Write-Host "User not found or error retrieving user." -ForegroundColor Red
    Disconnect-MgGraph
    return
}

Write-Host "Found $($user.DisplayName) <$($user.UserPrincipalName)>"
Write-Host "Retrieving assigned licenses..." -ForegroundColor Cyan

$assignedLicenses = Get-MgUserLicenseDetail -UserId $user.Id

if (-not $assignedLicenses) {
    Write-Host "No licenses assigned to this user." -ForegroundColor Yellow
} else {
    $assignedLicenses | Select-Object SkuPartNumber, SkuId | Format-Table -AutoSize
}

Disconnect-MgGraph
