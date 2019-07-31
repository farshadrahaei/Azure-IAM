# this script wrote by Farshad Rahaei  
# www.linkedin.com/in/farshadrahaei 
# https://github.com/farshadrahaei/

write-host "This script update Azure AD user information, user will be automatically granted proper permission based on group and title information entered here " -ForegroundColor Red -BackgroundColor Yellow
write-host "Please enter the information carefully !!!" -ForegroundColor Red 
write-host " "
write-host " "
$add="Yes"
if ($add -match "yes"){
do{
$confirm="No"
if ($confirm -match "no"){
do{
$email = Read-Host 'Please enter the username(User Email address used to login to Azure AD Varian.com)'
$UserId= (Get-AzureADUser -Filter "OtherMails eq '$email'").ObjectId
if (!$UserId){
do  { 
$email = Read-Host 'You entered the wrong Azure user email address, please enter the right address'
$UserId= (Get-AzureADUser -Filter "OtherMails eq '$email'").ObjectId} until ($UserId)
}
$Userdisplayname= (Get-AzureADUser -Filter "OtherMails eq '$email'").DisplayName
$ticketnum=Read-Host 'Please enter the ticket number'
$ticketdate=Read-Host 'Please enter the ticket date'
$ticket='Ticket number '+ $ticketnum+', dated '+$ticketdate
$departmentnum='beign'
if ($departmentnum -notmatch "^\d+$"){
do{
$departmentnum=Read-Host ’What is user group name ?
0)  Example Team

Please enter coresponding number from the list’}
until($departmentnum -match "^\d+$")}
$titlenum='begin'
if ($titlenum -notmatch "^\d+$"){
do{
$titlenum=Read-Host ’What is user Job Title?
0)	Example SME
1)	Job Title is not listed here
Please enter coresponding number from the list’}
until($titlenum -match "^\d+$")}
$department="Example Team""
$title="Example SME"," "
write-host "Please Confirm below information:" -ForegroundColor Green 
write-host "Username :"$Userdisplayname -ForegroundColor Red -BackgroundColor Yellow
write-host "Group Name :"$department[$departmentnum] -ForegroundColor Red -BackgroundColor Yellow
write-host "Title :"$title[$titlenum] -ForegroundColor Red -BackgroundColor Yellow
write-host $ticket -ForegroundColor Red -BackgroundColor Yellow
$confirm= Read-Host 'Are above infomration Correct? Please type Yes or No'
}
until ($confirm -match "yes")

}
$runner=whoami
$LogPath="/home/$runner/newtest.json"
$TimeStamp = ($TimeStamp = Get-Date).Datetime
$out=@{RunningTime=$TimeStamp;UserName=$Userdisplayname;UserObjectId=$UserId;DepartmentName=$department[$departmentnum];UserTitle=$title[$titlenum];TicketInformation=$ticket;RunningUser=$runner}
if (Test-Path -Path $LogPath){
$existingfile=Get-Content $LogPath
(($out|ConvertTo-Json)+$existingfile)| Out-File $LogPath
}
else
{
($out|ConvertTo-Json)| Out-File $LogPath
}



Set-AzureADUser -ObjectId $UserId -Department $department[$departmentnum] -JobTitle $title[$titlenum] -PostalCode $ticket
write-host "User information has been updated" -ForegroundColor Green 
$add=Read-Host ’Do you want to update any other user information? Please enter Yes or No.'
}
until($add -match "no")
}

