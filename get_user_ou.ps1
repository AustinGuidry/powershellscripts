#If, for some reason, you want to see an AD user's OU

Import-Module ActiveDirectory

$UserName = Read-Host "Please enter the person's username"

$user = Get-ADUser -Identity $UserName -Properties DistinguishedName

$ou = ($user.DistinguishedName -split ',CN=')[0]

Write-Host "The OU for $username is: $ou"