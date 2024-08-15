Function Select-Subscription {
    $AzSubscriptionID = @()
  $AzSubscription = get-azsubscription
  write-host "=============================================" -ForegroundColor Green
  for ($i = 0; $i -lt $AzSubscription.length; $i++) {write-host "[$i] - $($AzSubscription[$i].Name) - $($AzSubscription[$i].Id)"}
  write-host "=============================================" -ForegroundColor Green
  if(-not($AzSubscriptionID)) {[int]$AzSubscriptionID =  Read-Host -Prompt "Select Subscription "}
  Select-AzSubscription $AzSubscription[$AzSubscriptionID].Id
}