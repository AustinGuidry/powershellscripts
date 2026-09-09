#You've installed MS Graph and just want to test it - nothing crazy - does it work at a basic level?

Import-Module Microsoft.Graph.Authentication
Import-Module Microsoft.Graph.Users

Connect-MgGraph -Scopes "User.ReadBasic.All"

$user = Read-Host "Please enter a user's email address"

try {
    $userdetails = Get-MgUser -UserId $user -ErrorAction Stop
    Write-Host "    "
    Write-Host "Display Name:" $userdetails.DisplayName
    Write-Host "User Principal Name (UPN):" $userdetails.UserPrincipalName
    Write-Host "    "
}
catch {
    Write-Host "An Error Occurred: $($_.Exception.Message)"
}
