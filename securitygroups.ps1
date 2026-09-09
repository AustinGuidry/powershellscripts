#Lists the groups an AD user is a member of.

Import-Module ActiveDirectory

$UserName = Read-Host "Enter username here:"

#The parameter is -Properties, plural. -Property is not an accepted
#abbreviation of it and errors out.
try {
    $Groups = Get-ADUser -Identity $UserName -Properties MemberOf -ErrorAction Stop |
        Select-Object -ExpandProperty MemberOf
}
catch {
    Write-Host "Could not find AD user '$UserName': $($_.Exception.Message)" -ForegroundColor Red
    return
}

#Worth knowing: MemberOf leaves out the user's primary group, which is
#normally Domain Users, so that one won't show up in this list.
if ($Groups) {
    Write-Host "`nUser '$UserName' is a member of the following groups:`n" -ForegroundColor Cyan
    $Groups | ForEach-Object {
        $GroupName = (Get-ADGroup -Identity $_).Name
        Write-Host $GroupName -ForegroundColor Green
    }
} else {
    Write-Host " '$UserName' is not a part of any groups." -ForegroundColor Yellow
}
