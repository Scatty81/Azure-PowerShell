Place this file into the module directory as described [here](../readme.md#install-cloud-modules)  

With this module you can select a subscription just by entering the number.

Usage: `Select-Subscription`  
output:
```
=============================================
[0] - Mission Critical - 613bc978-6e6e-4c32-9ced-3ca80e2e0fca
[1] - Protected Data - 7c68a442-3f1f-46e5-9827-5135788be074
[2] - Prod - 375f55ec-a8b8-488d-979c-16fb86eea6fb
[3] - Test environment - 08614a84-fc75-4ba1-9d96-191def49abb3
[4] - Web facing - 213401db-8dfd-4192-a3fd-b8e63fe77edd
=============================================
Select Subscription : 2

  Tenant: 4fcc7fe4-ad93-4666-85d2-f34c4a671030

SubscriptionName             SubscriptionId                       Account   Environment
----------------             --------------                       -------   -----------
Prod                         375f55ec-a8b8-488d-979c-16fb86eea6fb MSI@1000  AzureCloud

PS />
```


### Select subscription during login 

Place the following code into the 
`Microsoft.PowerShell_profile.ps1`  under `/home/YOURNAME/.config/PowerShell`

```PowerShell
$AzSubscriptionID = @()
$AzSubscription = get-azsubscription
write-host "=============================================" -ForegroundColor Green
for ($i = 0; $i -lt $AzSubscription.length; $i++) {write-host "[$i] - $($AzSubscription[$i].Name) - $($AzSubscription[$i].Id)"}
write-host "=============================================" -ForegroundColor Green
if(-not($AzSubscriptionID)) {[int]$AzSubscriptionID =  Read-Host -Prompt "Select Subscription "}
Select-AzSubscription $AzSubscription[$AzSubscriptionID].Id
```
this way when you start the AzureCLI you will be prompted to select a subscription.