#Lists the groups a user belongs to, with their email address where they have one.

Import-Module Microsoft.Graph.Authentication
Import-Module Microsoft.Graph.Users

Write-Host "Connecting to MS Graph..." -ForegroundColor Cyan
Connect-MgGraph -Scopes "User.Read.All", "Group.Read.All", "Directory.Read.All" -UseDeviceCode
Write-Host "Connected to MS Graph." -ForegroundColor Green

$userInput = Read-Host "Enter the user's email address"
Write-Host "Looking up user '$userInput'..." -ForegroundColor Cyan

try {
    $user = Get-MgUser -UserId $userInput -Property Id,DisplayName,UserPrincipalName -ErrorAction Stop
} catch {
    Write-Host "User not found or error retrieving user." -ForegroundColor Red
    Disconnect-MgGraph
    return
}

Write-Host ""
Write-Host "User: $($user.DisplayName) <$($user.UserPrincipalName)>" -ForegroundColor Cyan
Write-Host ""

Write-Host "Retrieving group memberships..." -ForegroundColor Cyan

$memberships = Get-MgUserMemberOf -UserId $user.Id -All

#Get-MgUserMemberOf hands back bare directoryObject entries. The only real
#properties on those are Id and AdditionalProperties - the type discriminator,
#the display name and the email all live inside AdditionalProperties, so
#reading $_.'@odata.type' or $_.DisplayName directly just returns nothing.
$groups = $memberships | Where-Object {
    $_.AdditionalProperties['@odata.type'] -eq "#microsoft.graph.group"
}

if (-not $groups) {
    Write-Host "This user is not a member of any groups." -ForegroundColor Yellow
} else {
    Write-Host "Member of:" -ForegroundColor Green
    foreach ($group in $groups) {
        $groupName = $group.AdditionalProperties['displayName']
        $groupMail = $group.AdditionalProperties['mail']
        $groupEmail = if ($groupMail) { $groupMail } else { "(no email address)" }
        Write-Host "- $groupName ($groupEmail)"
    }
}

Disconnect-MgGraph
