Import-Module ActiveDirectory

$username = Read-Host -Prompt "Which username are we checking?"
Get-ADUser -Identity $username -Properties PasswordLastSet | Select-Object Name, PasswordLastSet