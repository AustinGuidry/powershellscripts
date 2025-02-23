$UserName = Read-Host "Enter username here:"

$Groups = Get-ADUser -Identity $UserName -Property MemberOf | Select-Object -ExpandProperty MemberOf

if ($Groups) {
    Write-Host "`nUser '$UserName' is a member of the following security groups:`n" -ForegroundColor Cyan
    $Groups | ForEach-Object { 
        $GroupName = (Get-ADGroup -Identity $_).Name
        Write-Host $GroupName -ForegroundColor Green
    }
} else {
    Write-Host " '$UserName' is not a part of any security groups." -ForegroundColor Yellow
}