$AzurePortalLoginUsername = "powershell@qingke.partner.onmschina.cn";
$AzurePortalLoginPassword = "4zycMr8rX@RDnTzc";
$SubscriptionName1 = "青客测试";
$SubscriptionName2 = "青客仿真";
$e1=Get-AzureRmEnvironment -Name AzureChinaCloud;
$Cred = New-Object System.Management.Automation.PSCredential($AzurePortalLoginUsername,(ConvertTo-SecureString $AzurePortalLoginPassword -AsPlainText -Force));
$AzureRMCred = Get-Credential -Credential $Cred;
Login-AzureRmAccount -Environment $e1 -Credential $AzureRMCred;


$rmvms=Get-AzureRmvm;

foreach ($vm in $rmvms)
{
	Write-Output ($vm.ResourceGroupName+','+$vm.NIC);
}