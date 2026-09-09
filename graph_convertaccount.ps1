#Hard matches an existing cloud-only 365 account to an on-prem AD account.

Import-Module ActiveDirectory
Import-Module Microsoft.Graph.Authentication
Import-Module Microsoft.Graph.Users

Connect-MgGraph -Scopes "User.ReadWrite.All"

$userEmail = Read-Host "Enter the user's email address (same for AD and 365)"

#SilentlyContinue so a missing user drops through to the check below rather
#than dumping a raw Graph error to the screen first.
$cloudUser = Get-MgUser -UserId $userEmail -ErrorAction SilentlyContinue

if ($null -eq $cloudUser) {
    Write-Error "Cloud user '$userEmail' not found."
    return
}

#A string filter rather than a script block - the { } form is fragile with
#variables and is best avoided with the AD cmdlets.
$onPremUser = Get-ADUser -Filter "UserPrincipalName -eq '$userEmail'" -Properties ObjectGUID, SamAccountName

if ($null -eq $onPremUser) {
    Write-Error "On-prem AD user with '$userEmail' not found."
    return
}

$immutableId = [System.Convert]::ToBase64String($onPremUser.ObjectGUID.ToByteArray())

Write-Host "Ready to hard match the following user:"
Write-Host " AD SamAccountName : $($onPremUser.SamAccountName)"
Write-Host " Cloud UPN         : $($cloudUser.UserPrincipalName)"
Write-Host " ImmutableID       : $immutableId"

$confirm = Read-Host "`nProceed with hard match? (y/n)"
if ($confirm -ne 'y') {
    Write-Host "Operation cancelled by user."
    return
}

Update-MgUser -UserId $cloudUser.Id -OnPremisesImmutableId $immutableId

Write-Host "Success! $userEmail is now linked between on-prem AD and Office 365."
