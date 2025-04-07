Import-Module Microsoft.Graph
Import-Module ImportExcel

Write-Host "Connecting to MS Graph..." -ForegroundColor Cyan
Connect-MgGraph -Scopes "User.Read.All", "Directory.Read.All" -UseDeviceCode
Write-Host "Connected to MS Graph." -ForegroundColor Green

Write-Host "Retrieving user information..." -ForegroundColor Cyan

$filter = "usageLocation eq 'US' and onPremisesSyncEnabled eq false"
$properties = "Id,DisplayName,UserPrincipalName,UsageLocation,OnPremisesSyncEnabled,LastPasswordChangeDateTime"

$users = Get-MgUser -All -Filter $filter -Property $properties

foreach ($user in $users) {
    if (
        $user.OnPremisesSyncEnabled -eq $null -and
        $user.UsageLocation -eq $usRegion
    ) {
        $allUsers += [PSCustomObject]@{
            DisplayName                = $user.DisplayName
            UserPrincipalName          = $user.UserPrincipalName
            UsageLocation              = $user.UsageLocation
            LastPasswordChangeDateTime = $user.LastPasswordChangeDateTime
        }
    }
}

Write-Host "Outputting to table..." -ForegroundColor Cyan

$excelPath = "$env:USERPROFILE\Documents\clouduserlist.xlsx"
$allUsers | Sort-Object LastPasswordChangeDateTime | Export-Excel -Path $excelPath -WorksheetName "US_Cloud_Users" -AutoSize -BoldTopRow -FreezeTopRow

Write-Host "The data has been successfully exported to $excelPath" -ForegroundColor Green

Disconnect-MgGraph
