. "$PSScriptRoot\Invoke-Parallel.ps1"

$AzurePortalLoginUsername = "powershell@qingke.partner.onmschina.cn";
$AzurePortalLoginPassword = "O65^CmvqZj@L6Rxa";
$SubscriptionName1 = "青客测试";
$SubscriptionName2 = "青客仿真";
$SubscriptionName3 = "青客备份";
$e1=Get-AzureRmEnvironment -Name AzureChinaCloud;
$Cred = New-Object System.Management.Automation.PSCredential($AzurePortalLoginUsername,(ConvertTo-SecureString $AzurePortalLoginPassword -AsPlainText -Force));
$AzureRMCred = Get-Credential -Credential $Cred;
Login-AzureRmAccount -Environment $e1 -Credential $AzureRMCred;

[void][system.Reflection.Assembly]::LoadFrom("C:\Program Files (x86)\MySQL\MySQL Connector Net 6.9.9\Assemblies\v4.0\MySql.Data.dll")
$Server="192.168.1.11"
$Database="qk_yunwei"
$user="qk_yunwei"
$Password="J28d9117967Jb48iVLqp"
$charset="utf8"
$connectionString ="server=$Server;uid=$user;pwd=$Password;database=$Database;charset=$charset"
$connection = New-Object MySql.Data.MySqlClient.MySqlConnection
$connection.ConnectionString = $connectionString
$connection.Open()

##关闭测试
Select-AzureRmSubscription -SubscriptionName $SubscriptionName3;
$rmvms=Get-AzureRmvm -status

$VMs=@{};
foreach ($vm in $rmvms)
{
	#Write-Output ($vm.ResourceGroupName);
	if ($vm.PowerState -eq "VM running"){
		$VMs[$vm.ResourceGroupName]+=$vm.name+';'
	}
}

foreach ($ResourceGroupName in $VMs.Keys)
{
    $vmnames = @();
    foreach($vmname in $VMs[$ResourceGroupName].Split(";"))
    {	
		if ($vmname -ne ""){
			$vmnames += $vmname;
		}
    }
    $vmnames | Invoke-Parallel -ImportVariables -NoCloseOnTimeout -ScriptBlock { 
		$reslut=Stop-AzureRmVM -ResourceGroupName $ResourceGroupName -Name $_ -Force
		if ($reslut.Status -eq 'Succeeded'){
			$sql="SELECT resname,name FROM azurevm where name='"+$_+"'";
			$command = New-Object MySql.Data.MySqlClient.MySqlCommand($sql, $connection)
			$dataAdapter = New-Object MySql.Data.MySqlClient.MySqlDataAdapter($command)
			$ds = New-Object System.Data.DataSet
			$recordCount = $dataAdapter.Fill($ds)
			if ($recordCount -gt 0){
				$sql = "update azurevm set state=0,delayedoff=0,closed=0,opened=0,ctime=now() where name='"+$_+"'"
				$command = New-Object MySql.Data.MySqlClient.MySqlCommand($sql, $connection)
				$command.ExecuteNonQuery()
			}else{
				$sql = "insert into azurevm(resname,name,vmtype,state,opened,closed,ctime) values('$ResourceGroupName','$_',3,0,0,0,now())"
				$command = New-Object MySql.Data.MySqlClient.MySqlCommand($sql, $connection)
				$command.ExecuteNonQuery()
			}
			
		}
	}
}
