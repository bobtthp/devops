$AzurePortalLoginUsername = "powershell@qingke.partner.onmschina.cn";
$AzurePortalLoginPassword = "4zycMr8rX@RDnTzc";
$SubscriptionName1 = "��Ͳ���";
$SubscriptionName2 = "��ͷ���";
$e1=Get-AzureRmEnvironment -Name AzureChinaCloud;
$Cred = New-Object System.Management.Automation.PSCredential($AzurePortalLoginUsername,(ConvertTo-SecureString $AzurePortalLoginPassword -AsPlainText -Force));
$AzureRMCred = Get-Credential -Credential $Cred;
Login-AzureRmAccount -Environment $e1 -Credential $AzureRMCred;


$rmvms=Get-AzureRmvm;

foreach ($vm in $rmvms)
{
	Write-Output ($vm.ResourceGroupName+','+$vm.NIC);
}