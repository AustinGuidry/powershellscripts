<#
    Adds a member to an Exchange Online distribution list / mail-enabled group.
    Prompts for the admin account, the list, and the member to add.
#>

# Make sure the Exchange Online management module is available before doing anything else.
if (-not (Get-Module -ListAvailable -Name ExchangeOnlineManagement)) {
    Write-Error "The 'ExchangeOnlineManagement' module isn't installed. Install it with: Install-Module -Name ExchangeOnlineManagement -Scope CurrentUser"
    exit 1
}

Import-Module ExchangeOnlineManagement -ErrorAction Stop

$adminEmail  = Read-Host "What's your email? (for Exchange Authentication)"
$listEmail   = Read-Host "What's the email list?"
$memberEmail = Read-Host "What's the email of the person you're adding?"

try {
    Connect-ExchangeOnline -UserPrincipalName $adminEmail -ErrorAction Stop

    # Confirm the list actually exists before trying to add anyone to it.
    $group = Get-DistributionGroup -Identity $listEmail -ErrorAction Stop

    Add-DistributionGroupMember -Identity $group.Identity -Member $memberEmail -ErrorAction Stop

    Write-Host "Added $memberEmail to $listEmail." -ForegroundColor Green
}
catch {
    Write-Error "Failed to add $memberEmail to $listEmail`: $($_.Exception.Message)"
}
finally {
    Disconnect-ExchangeOnline -Confirm:$false -ErrorAction SilentlyContinue
}
