#Tells you whether a user is synced from on-prem AD or is cloud-only.

Import-Module Microsoft.Graph.Authentication
Import-Module Microsoft.Graph.Users

Connect-MgGraph -Scopes "User.Read.All", "Directory.Read.All" -UseDeviceCode

$email = Read-Host -Prompt "Enter the user's email address"
Write-Output "Checking..."

#onPremisesSyncEnabled isn't in the default property set, so ask for it.
try {
    $user = Get-MgUser -UserId $email -Property "displayName,userPrincipalName,onPremisesSyncEnabled" -ErrorAction Stop
}
catch {
    Write-Output "User not in Microsoft 365. Please verify username + email."
    Disconnect-MgGraph
    return
}

$syncStatus = if ($user.OnPremisesSyncEnabled) { "On-Premises" } else { "Cloud" }

Write-Output "User: $($user.DisplayName)"
Write-Output "Email: $($user.UserPrincipalName)"
Write-Output "Sync Status: $syncStatus"

Disconnect-MgGraph
