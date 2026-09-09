#Exports cloud-only users and when they last changed their password.

Import-Module Microsoft.Graph.Authentication
Import-Module Microsoft.Graph.Users
Import-Module ImportExcel

#Which usageLocation to report on.
$UsageLocation = 'US'

Write-Host "Connecting to MS Graph..." -ForegroundColor Cyan
Connect-MgGraph -Scopes "User.Read.All", "Directory.Read.All" -UseDeviceCode
Write-Host "Connected to MS Graph." -ForegroundColor Green

Write-Host "Retrieving user information..." -ForegroundColor Cyan

$filter = "usageLocation eq '$UsageLocation'"
$properties = "Id,DisplayName,UserPrincipalName,UsageLocation,OnPremisesSyncEnabled,LastPasswordChangeDateTime"

$users = Get-MgUser -All -Filter $filter -Property $properties

$allUsers = @()

foreach ($user in $users) {
    #Cloud-only accounts report onPremisesSyncEnabled as null rather than
    #false, so this is filtered here instead of in the Graph filter above -
    #"onPremisesSyncEnabled eq false" server-side would match none of them.
    if ($user.OnPremisesSyncEnabled -ne $true) {
        $allUsers += [PSCustomObject]@{
            DisplayName                = $user.DisplayName
            UserPrincipalName          = $user.UserPrincipalName
            UsageLocation              = $user.UsageLocation
            LastPasswordChangeDateTime = $user.LastPasswordChangeDateTime
        }
    }
}

if ($allUsers.Count -eq 0) {
    Write-Host "No cloud-only users found with usageLocation '$UsageLocation'. Nothing to export." -ForegroundColor Yellow
    Disconnect-MgGraph
    return
}

Write-Host "Outputting to table..." -ForegroundColor Cyan

$excelPath = "$env:USERPROFILE\Documents\clouduserlist.xlsx"
$allUsers | Sort-Object LastPasswordChangeDateTime | Export-Excel -Path $excelPath -WorksheetName "$($UsageLocation)_Cloud_Users" -AutoSize -BoldTopRow -FreezeTopRow

Write-Host "The data has been successfully exported to $excelPath" -ForegroundColor Green

Disconnect-MgGraph
