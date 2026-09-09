#Shows when an AD user last set their password.

Import-Module ActiveDirectory

$username = Read-Host -Prompt "Which username are we checking?"

try {
    Get-ADUser -Identity $username -Properties PasswordLastSet -ErrorAction Stop |
        Select-Object Name, PasswordLastSet
}
catch {
    Write-Host "Could not find AD user '$username': $($_.Exception.Message)"
}
