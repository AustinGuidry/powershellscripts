#Pulls a basic profile for a single user out of Microsoft 365 / Entra ID.

Import-Module Microsoft.Graph.Authentication
Import-Module Microsoft.Graph.Users

#Change this if your users aren't in US Central time.
$TimeZoneId = 'Central Standard Time'

Connect-MgGraph -Scopes "User.Read.All" -NoWelcome

$user = Read-Host "Enter the user's email address"

Write-Output "Retrieving user details..."

try {
    $userDetails = Get-MgUser -UserId $user -Property "displayName,givenName,surname,mail,jobTitle,department,officeLocation,employeeId,accountEnabled,createdDateTime" -ErrorAction Stop
}
catch {
    Write-Output "User not found, or an error occurred: $($_.Exception.Message)"
    return
}

#createdDateTime arrives as UTC. It can also come back empty, which would
#blow up the conversion, so only convert it when there's something there.
if ($null -ne $userDetails.CreatedDateTime) {
    $createdDate = [System.TimeZoneInfo]::ConvertTimeBySystemTimeZoneId($userDetails.CreatedDateTime, $TimeZoneId)
}
else {
    $createdDate = "(not available)"
}

Write-Output " "
Write-Output "User Details:"
Write-Output " "
Write-Output "Display Name: $($userDetails.DisplayName)"
Write-Output "First Name: $($userDetails.GivenName)"
Write-Output "Last Name: $($userDetails.Surname)"
Write-Output "Email: $($userDetails.Mail)"
Write-Output "Job Title: $($userDetails.JobTitle)"
Write-Output "Department: $($userDetails.Department)"
Write-Output "Office Location: $($userDetails.OfficeLocation)"
Write-Output "Employee ID: $($userDetails.EmployeeId)"
Write-Output "Account Enabled: $($userDetails.AccountEnabled)"
Write-Output "Created Date: $createdDate"
Write-Output " "
