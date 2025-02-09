Import-Module ActiveDirectory

$username = Read-Host -Prompt "Which user are we unlocking?"
Unlock-ADAccount -Identity $username
Write-Host "$username's account has been successfully unlocked!"