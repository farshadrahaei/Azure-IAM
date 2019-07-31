

$SubID = Read-Host 'Please enter New Subscription ID'
$Sub= “/subscriptions/$SubID"
write-host "Scope of bellow Custom Roles has been updated with Subscription " $SubID -ForegroundColor Green 
if($rolesecurity = Get-AzRoleDefinition "Example Reader Custom"
$rolesecurity.AssignableScopes.Add($Sub)
Set-AzRoleDefinition -Role $rolesecurity){
write-host "Example Reader Custom" -ForegroundColor Red -BackgroundColor Yellow}


write-host " " 
write-host " " 

$ExampleGroup="fl98f1e6-45ke-00ae-jh6f-0ak182687a7"


write-host "Bellow Security Access Roles has been assigned to the Subscription:" $SubID -ForegroundColor Green 

 
if (New-AzRoleAssignment -ObjectId $Security `
  -RoleDefinitionName "Example Reader Custom" `
  -Scope $Sub){
write-host "Group Name: Example Group" $ExampleGroup -ForegroundColor Red -BackgroundColor Yellow
write-host "Role: Example Reader Custom" -ForegroundColor Red -BackgroundColor Yellow
write-host " "} 
 


  