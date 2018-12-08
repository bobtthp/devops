. "$PSScriptRoot\Invoke-Parallel.ps1"
$AzurePortalLoginUsername = "powershell@qingke.partner.onmschina.cn";
$AzurePortalLoginPassword = "O65^CmvqZj@L6Rxa";
$SubscriptionName1 = "青客仿真";
$SubscriptionName2 = "青客测试";
$SubscriptionName3 = "青客备份";
$e1=Get-AzureRmEnvironment -Name AzureChinaCloud;
$Cred = New-Object System.Management.Automation.PSCredential($AzurePortalLoginUsername,(ConvertTo-SecureString $AzurePortalLoginPassword -AsPlainText -Force));
$AzureRMCred = Get-Credential -Credential $Cred;
Login-AzureRmAccount -Environment $e1 -Credential $AzureRMCred;

#[void][System.Reflection.Assembly]::LoadWithPartialName("MySql.Data")
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





#青客仿真开机判断
$sql="SELECT resname,name FROM azurevm where vmtype=1 and ((opened=1) or (autostart=1 and state!=1))";
$command = New-Object MySql.Data.MySqlClient.MySqlCommand($sql, $connection)
$dataAdapter = New-Object MySql.Data.MySqlClient.MySqlDataAdapter($command)
$ds = New-Object System.Data.DataSet
$recordCount = $dataAdapter.Fill($ds)

if ($recordCount -ge 1){
	Select-AzureRmSubscription -SubscriptionName $SubscriptionName1;
	$VMs=@{};
	foreach($table in $ds.Tables)
	{
		foreach($row in $table.Rows)
		{
			$VMs[$row.resname]+=$row.name+';'
		}
	}
	foreach ($ResourceGroupName in $VMs.Keys){
		$vmnames = @();
		foreach($vmname in $VMs[$ResourceGroupName].Split(";"))
		{	
			if ($vmname -ne ""){
				$vmnames += $vmname;
			}
		}
		$vmnames | Invoke-Parallel -ImportVariables -NoCloseOnTimeout -ScriptBlock { 
			$StartRtn=Start-AzureRmVM -ResourceGroupName $ResourceGroupName -Name $_ -ErrorAction Continue
			if ($StartRtn.Status -eq 'Succeeded')
			{
				$sql = "update azurevm set opened=0,state=1,otime=now() where name='"+$_+"'"
				$command = New-Object MySql.Data.MySqlClient.MySqlCommand($sql, $connection)
				$command.ExecuteNonQuery()
			}
		}
	}
}

#青客测试开机判断
$sql="SELECT resname,name FROM azurevm where vmtype=2 and (	(opened=1) or (autostart=1 and state!=1) )";
$command = New-Object MySql.Data.MySqlClient.MySqlCommand($sql, $connection)
$dataAdapter = New-Object MySql.Data.MySqlClient.MySqlDataAdapter($command)
$ds = New-Object System.Data.DataSet
$recordCount = $dataAdapter.Fill($ds)

if ($recordCount -ge 1){
	Select-AzureRmSubscription -SubscriptionName $SubscriptionName2;
	$VMs=@{};
	foreach($table in $ds.Tables)
	{
		foreach($row in $table.Rows)
		{
			$VMs[$row.resname]+=$row.name+';'
		}
	}
	foreach ($ResourceGroupName in $VMs.Keys){
		$vmnames = @();
		foreach($vmname in $VMs[$ResourceGroupName].Split(";"))
		{	
			if ($vmname -ne ""){
				$vmnames += $vmname;
			}
		}
		$vmnames | Invoke-Parallel -ImportVariables -NoCloseOnTimeout -ScriptBlock { 
			$StartRtn=Start-AzureRmVM -ResourceGroupName $ResourceGroupName -Name $_ -ErrorAction Continue
			if ($StartRtn.Status -eq 'Succeeded')
			{
				$sql = "update azurevm set opened=0,state=1,otime=now() where name='"+$_+"'"
				$command = New-Object MySql.Data.MySqlClient.MySqlCommand($sql, $connection)
				$command.ExecuteNonQuery()
			}
		}
	}
}


#青客仿真关机判断
$sql="SELECT resname,name FROM azurevm where closed=1 and vmtype=1 and autostart!=1";
$command = New-Object MySql.Data.MySqlClient.MySqlCommand($sql, $connection)
$dataAdapter = New-Object MySql.Data.MySqlClient.MySqlDataAdapter($command)
$ds = New-Object System.Data.DataSet
$recordCount = $dataAdapter.Fill($ds)

if ($recordCount -ge 1){
	Select-AzureRmSubscription -SubscriptionName $SubscriptionName1;
	$VMs=@{};
	foreach($table in $ds.Tables)
	{
		foreach($row in $table.Rows)
		{
			$VMs[$row.resname]+=$row.name+';'
		}
	}
	foreach ($ResourceGroupName in $VMs.Keys){
		$vmnames = @();
		foreach($vmname in $VMs[$ResourceGroupName].Split(";"))
		{	
			if ($vmname -ne ""){
				$vmnames += $vmname;
			}
		}
		$vmnames | Invoke-Parallel -ImportVariables -NoCloseOnTimeout -ScriptBlock { 
			$StartRtn=$reslut=Stop-AzureRmVM -ResourceGroupName $ResourceGroupName -Name $_ -Force
			if ($StartRtn.Status -eq 'Succeeded')
			{
				$sql = "update azurevm set state=0,closed=0,ctime=now() where name='"+$_+"'"
				$command = New-Object MySql.Data.MySqlClient.MySqlCommand($sql, $connection)
				$command.ExecuteNonQuery()
			}
		}
	}
}

#青客测试关机判断
$sql="SELECT resname,name FROM azurevm where closed=1 and vmtype=2 and autostart!=1";
$command = New-Object MySql.Data.MySqlClient.MySqlCommand($sql, $connection)
$dataAdapter = New-Object MySql.Data.MySqlClient.MySqlDataAdapter($command)
$ds = New-Object System.Data.DataSet
$recordCount = $dataAdapter.Fill($ds)

if ($recordCount -ge 1){
	Select-AzureRmSubscription -SubscriptionName $SubscriptionName2;
	$VMs=@{};
	foreach($table in $ds.Tables)
	{
		foreach($row in $table.Rows)
		{
			$VMs[$row.resname]+=$row.name+';'
		}
	}
	foreach ($ResourceGroupName in $VMs.Keys){
		$vmnames = @();
		foreach($vmname in $VMs[$ResourceGroupName].Split(";"))
		{	
			if ($vmname -ne ""){
				$vmnames += $vmname;
			}
		}
		$vmnames | Invoke-Parallel -ImportVariables -NoCloseOnTimeout -ScriptBlock { 
			$StartRtn=$reslut=Stop-AzureRmVM -ResourceGroupName $ResourceGroupName -Name $_ -Force
			if ($StartRtn.Status -eq 'Succeeded')
			{
				$sql = "update azurevm set state=0,closed=0,ctime=now() where name='"+$_+"'"
				$command = New-Object MySql.Data.MySqlClient.MySqlCommand($sql, $connection)
				$command.ExecuteNonQuery()
			}
		}
	}
}





$connection.Close()
