#if you have a cloud-only user who needs an AD account

try {
    $username = Read-Host "Enter to-be synced user's email address"
    Connect-MsolService
    $user = Get-ADUser -Filter {UserPrincipalName -eq $username}
    if ($user -eq $null) {
        throw "Active Directory user not found."
    }
    $id = [System.Convert]::ToBase64String($user.ObjectGUID.ToByteArray())
    Set-SsolUser -PrincipalName $username -ImmutableId $id
    Write-Host "The account has been updated successfully. Please wait for servers to sync or perform a manual sync."
} catch {
    Write-Host "An error occured: $_"
}