#Unlocks a locked-out AD account.

Import-Module ActiveDirectory

$username = Read-Host -Prompt "Which user are we unlocking?"

#-ErrorAction Stop so a failure lands in the catch instead of printing an
#error and then cheerfully claiming the unlock succeeded.
try {
    Unlock-ADAccount -Identity $username -ErrorAction Stop
    Write-Host "$username's account has been successfully unlocked!"
}
catch {
    Write-Host "Could not unlock '$username': $($_.Exception.Message)"
}
