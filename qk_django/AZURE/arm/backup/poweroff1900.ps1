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

$AzurePortalLoginUsername = "powershell@qingke.partner.onmschina.cn";
$AzurePortalLoginPassword = "O65^CmvqZj@L6Rxa";
$SubscriptionName1 = "青客测试";
$SubscriptionName2 = "青客仿真";
$SubscriptionName3 = "青客备份";
$e1=Get-AzureRmEnvironment -Name AzureChinaCloud;
$Cred = New-Object System.Management.Automation.PSCredential($AzurePortalLoginUsername,(ConvertTo-SecureString $AzurePortalLoginPassword -AsPlainText -Force));
$AzureRMCred = Get-Credential -Credential $Cred;
Login-AzureRmAccount -Environment $e1 -Credential $AzureRMCred;


#19点执行
$sql="SELECT name FROM azurevm where state=1 and delayedoff=1"
$command = New-Object MySql.Data.MySqlClient.MySqlCommand($sql, $connection)
$dataAdapter = New-Object MySql.Data.MySqlClient.MySqlDataAdapter($command)
$ds = New-Object System.Data.DataSet
$recordCount = $dataAdapter.Fill($ds)

$names = New-Object -TypeName System.Collections.ArrayList
foreach($table in $ds.Tables)
{
	foreach($row in $table.Rows)
	{
		foreach ($column in $table.Columns)
			{
				$rowcount=$names.Add([string]$row[$column])
			}
	}
}

#$names


#19点关闭未延时的测试
Select-AzureRmSubscription -SubscriptionName $SubscriptionName1;
$VMs = Get-AzureRmvm -status
foreach ($VM in $VMs)
{	
	if ($VM.PowerState -eq "deallocated")
	{
		# The VM is already Stopped, so send notice
		#Write-Output ($VM.InstanceName + " is already stopped")
	}else
	{
		$noshutdown=0
		foreach ($name in $names)
		{
			if ($VM.Name -eq $name){
				$noshutdown=1;
			}
		}
		if ($noshutdown -eq 1){
			Write-Output ($(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')+" "+$VM.Name + " in no_poweroff list") >> logs\poweroff.txt
		}else{
			$StopRtn = Stop-AzureRmVM -ResourceGroupName $VM.ResourceGroupName -Name $VM.Name -Force -ErrorAction Continue
			if ($StopRtn.Status -ne 'Succeeded')
			{
				# The VM failed to stop, so send notice
				Write-Output ($(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')+" "+$VM.Name + " failed to stop") >> logs\poweroff.txt
			}
			else
			{
				# The VM stopped, so send notice
				$sql = "update azurevm set state=0 where name='"+$VM.Name+"'";
				$command = New-Object MySql.Data.MySqlClient.MySqlCommand($sql, $connection)
				$command.ExecuteNonQuery()
				Write-Output ($(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')+" "+$VM.Name + " has been stopped") >> logs\poweroff.txt
			}
		}
		
	}

}

#19点关闭未延时的仿真
Select-AzureRmSubscription -SubscriptionName $SubscriptionName2;
$VMs = Get-AzureRmvm -status
foreach ($VM in $VMs)
{	
	if ($VM.PowerState -eq "deallocated")
	{
		# The VM is already Stopped, so send notice
		#Write-Output ($VM.InstanceName + " is already stopped")
	}else
	{
		$noshutdown=0
		foreach ($name in $names)
		{
			if ($VM.Name -eq $name -or $VM.Name -eq "qks-138"){
				$noshutdown=1;
			}
		}
		if ($noshutdown -eq 1){
			Write-Output ($(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')+" "+$VM.Name + " in no_poweroff list") >> logs\poweroff.txt
		}else{
			$StopRtn = Stop-AzureRmVM -ResourceGroupName $VM.ResourceGroupName -Name $VM.Name -Force -ErrorAction Continue
			if ($StopRtn.Status -ne 'Succeeded')
			{
				# The VM failed to stop, so send notice
				Write-Output ($(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')+" "+$VM.Name + " failed to stop") >> logs\poweroff.txt
			}
			else
			{
				# The VM stopped, so send notice
				$sql = "update azurevm set state=0 where name='"+$VM.Name+"'";
				$command = New-Object MySql.Data.MySqlClient.MySqlCommand($sql, $connection)
				$command.ExecuteNonQuery()
				Write-Output ($(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')+" "+$VM.Name + " has been stopped") >> logs\poweroff.txt
			}
		}
		
	}

}


$connection.Close()

