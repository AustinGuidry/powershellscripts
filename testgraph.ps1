#You've installed MS Graph and just want to test it - nothing crazy - does it work at a basic level? 
Import-Module Microsoft.Graph
Connect-MgGraph -Scopes "User.ReadBasic.All"

$user = Read-Host "Please enter a user's email address"

try {
    $userdetails = Get-MgUser -UserId $user 
    Write-Host "    "
    Write-Host "Display Name:" $($userdetails.userdisplayname)
    Write-Host "User Principal Name (UPN):" $($userdetails.userprincipalname)
    Write-Host "    "
}
catch {
    Write-Host "An Error Occurred: $($_.Exception.Message)"
}