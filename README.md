# Azure-IAM
PowerShell scripts to Automate Identity Access Managment on Azure

<h1>Automation on Azure Identity Access Management using PowerShell scripting</h1>

**Introduction**:

For the enterprises with multiple subscriptions in Azure cloud assigning the permission to the engineers working on the Azure resources could be challenging as you may need to assign the same/different level of permissions to multiple new/existing subscriptions either manually or using “Management Groups” and “Azure Blueprints”. <br />
Using “Management Groups” you could assign the permission to the group of subscriptions that are joined to the management group, but that great Azure services currently has a limitation that don’t let you assign custom role based access to the subscriptions.<br />

As of security best practice you always need to assign the permission to the engineers based on minimum required level of permissions, using built-in RBAC there would some scenarios that built-in RBAC provide higher level of privilege than needed and you will need to create the custom RBAC based on your needs.

**Purpose**:

Using Automation and PowerShell scripting we can automate process of assigning the permissions to the user/groups and keep consistency to assign the same level of permission to the new subscriptions.<br />

In this tutorial I will explain fully automated Azure Identity Access Management scenario with script examples:

Part 1: Assign the users automatically to the Azure AD groups using dynamic membership roles

Part 2: Modify Azure AD user’s information using Powershell script to match with Azure AD Group Dynamic Rules.

Part 3:  Create a custom RBAC with read access to all Azure resources, this custom RBAC provide more comprehensive read access than built-in “Reader” RBAC and could be used for audit purposes.

Part 4: Grant permission on subscription level to the Azure AD Groups using Powershell scripting.


*Attention: This instruction assume you’re using minimum P1 or P2 Azure AD licenses in your Azure Cloud environment and also familiar with basic PowerShell and JSON scripting.*



<br />

  
**Part 1**:

Assign the users automatically to the Azure AD groups using dynamic membership roles, in this example we will matching user’s department and job title for the existing Azure AD group.<br />

Go to Azure Active Directory → Groups → Dynamic membership rules → Advance rule <br />

and add bellow code to advance rules:<br />

(user.department -match “Example Team”) -and user.jobtitle -match “Example SME” <br />

This code will match all users that has department value equal to “Example Team” and Job Title equal to “Example SME” and them automatically to the Azure AD group. In my experience it take couple of minutes to users be added to the group automatically. <br />


![Dynamic Membership rule](https://github.com/farshadrahaei/Azure-IAM/blob/master/dynamic%20membership%20rule.jpg)

<br />

  
**Part 2**: 

Modify Azure Active Directory user’s information using Powershell script to match with Azure AD Group Dynamic Rules. <br />

Script start with the prompt to enter Azure user email address and it will check email address against Azure AD for existence of the corresponding Azure AD user, then it will request for ticket number and date and will update those information on Postalcode. Probably user’s PostalCode is not a best place to save those information but in this scenario I wanted to keep the ticket information for future audit and security purposes saved somewhere at user’s information. <br />

Script again will prompt for the Group name and user Job Title, that’s where you could modify the script and add more groups and job titles based on your needs. <br />

After updating those values on user information it will generate a json log file and include the name of person who ran the script and all values that has been updated. This log could be send to Azure log Analytics and kept there for maximum of 2 years for audit purpose. Please let me know in comments if you’re interested to get code to send the logs to Azure Analytics then I will post the instruction later. This script is designed to be smart and if user enter wrong value it will not let you pass to the next steps. <br />

Here is the example of powershell script: <br />


https://github.com/farshadrahaei/Azure-IAM/blob/master/user.ps1

You can run this script on Azure Cloud Shell; PowerShell Module.

<br />

  
**Part 3**:  

Create a custom RBAC with read access to all Azure resources, this custom RBAC provide more comprehensive read access than built-in “Reader” RBAC and could be used for audit purposes.<br />


First step, you need to create a json file and include bellow information on that:
- Name: name of custom RBAC
- IsCustom: true
- Description: description of the custom RBAC
- Actions: list all permissions you want to include on this custom RBAC, you can find list of available Azure Actions on bellow link:

https://docs.microsoft.com/en-us/azure/role-based-access-control/built-in-roles

- AssignableScopes : Azure subscription ID that you want custom RBAC be assignable

Here is the JSON file example for your reference:

https://github.com/farshadrahaei/Azure-IAM/blob/master/ExampleReaderCustom.json


Second step, you will need to go to cloud shell Bash Module and upload the json file to the cloud shell storage. 
![Upload file to Azure CloudShell](https://github.com/farshadrahaei/Azure-IAM/blob/master/cloudshell%20bash%20upload.jpg)

<br />

Third Step, run bellow command:<br />

az role definition –role-definition /home/username/ExampleReaderCustom.json 
<br />

You need to change the username on above command with your actual username that being used in cCoudshell, you can always find it on cloud shell cli prompt. <br />

The format is    username@Azure:-$  

<br />

  
**Part 4**: 

Grant permission on subscription level to the Azure AD Groups using Powershell scripting.<br />

Script start with the prompt to enter the subscription id, and assumption is that you already created some custom RBAC for other subscription and you want to add the new subscription to the assignable scope of those custom RBAC. <br />

Then it will add subscription id to assignable scope of custom RBAC.<br />

In the next step it will assign particular RBAC (could be custom or built-in RBAC) to the specific group for the subscription.<br />


Note: You need to create object for all existing Azure AD groups and embedded the group id in the script <br />


Here is the PowerShell script example for your reference: <br />


https://github.com/farshadrahaei/Azure-IAM/blob/master/subscription.ps1 <br />


This script could be run in Azure Cloud Shell; PowerShell module.





