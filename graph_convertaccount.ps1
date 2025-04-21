
Import-Module ActiveDirectory
Connect-MgGraph -Scopes "User.ReadWrite.All"

$userEmail = Read-Host "Enter the user's email address (same for AD and 365)"
$cloudUser = Get-MgUser -UserId $userEmail

if ($null -eq $cloudUser) {
    Write-Error "Cloud user '$userEmail' not found."
    return
}

$onPremUser = Get-ADUser -Filter { UserPrincipalName -eq $userEmail }

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

Write-Host "Success! $useremail is now linked between on-prem AD and Office 365."
