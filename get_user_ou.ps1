#If, for some reason, you want to see an AD user's OU

Import-Module ActiveDirectory

$UserName = Read-Host "Please enter the person's username"

try {
    $user = Get-ADUser -Identity $UserName -Properties DistinguishedName -ErrorAction Stop
}
catch {
    Write-Host "Could not find AD user '$UserName': $($_.Exception.Message)"
    return
}

#Chop the leading CN= component off the DN, which leaves the container the
#user actually sits in. Splitting on ',CN=' doesn't work here - a normal DN
#looks like "CN=John Doe,OU=Sales,DC=example,DC=com" and has no ',CN=' in it
#at all, so the whole DN comes back unchanged. The pattern below also copes
#with escaped commas in the name, e.g. "CN=Doe\, John,OU=Sales,...".
$ou = $user.DistinguishedName -replace '^CN=(?:[^,\\]|\\.)*,', ''

Write-Host "The OU for $UserName is: $ou"
