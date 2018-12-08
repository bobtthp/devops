Select-AzureSubscription ¨CSubscriptionName "Çà¿Í·ÂÕæ"
$allservice=Get-AzureService
 
$i=0
 
foreach($ser in $allservice)
{
  $allvms=Get-AzureVM -ServiceName $ser.ServiceName
  foreach($vm in $allvms)
  {
  write-host "ServiceName:",$vm.servicename,"VMname:",$vm.Name,"Size:",$vm.Instancesize
  $i=$i+1
  }
  Write-Host ""
 
}
 
Write-Host "Number:",$i