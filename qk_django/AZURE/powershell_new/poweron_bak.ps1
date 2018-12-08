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
$sql="SELECT name FROM azurevm where opened=1"
$command = New-Object MySql.Data.MySqlClient.MySqlCommand($sql, $connection)
$dataAdapter = New-Object MySql.Data.MySqlClient.MySqlDataAdapter($command)
$ds = New-Object System.Data.DataSet
$recordCount = $dataAdapter.Fill($ds)

#开机判断
if ($recordCount -ge 1){

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
	
	
	#测试账号
	Select-AzureSubscription "青客测试" -Current
	$VMs = Get-AzureVM
	foreach ($VM in $VMs)
	{	
		if ($VM.PowerState -eq "Started")
		{
			#Write-Output ($VM.InstanceName + " is already stopped")
		}else
		{
			$poweron=0
			foreach ($name in $names)
			{
				if ($VM.Name -eq $name){
					$poweron=1;
				}
			}
			if ($poweron -eq 1){
				$StartRtn = Start-AzureVM -Name $VM.Name -ServiceName $VM.ServiceName -ErrorAction Continue
				if ($StartRtn.OperationStatus -ne 'Succeeded')
				{
					# The VM failed to stop, so send notice
					Write-Output ($(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')+" "+$VM.InstanceName + " failed to start") >> logs\poweron.txt
				}
				else
				{
					# The VM stopped, so send notice
					# The VM failed to stop, so send notice
					$sql = "update azurevm set opened=0,state=1 where name='"+$VM.InstanceName+"'"
					$command = New-Object MySql.Data.MySqlClient.MySqlCommand($sql, $connection)
					$command.ExecuteNonQuery()
					Write-Output ($(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')+" "+$VM.InstanceName + " has been started") >> logs\poweron.txt
				}
				
			}
			
		}
	
	}
	
	#仿真账号
	Select-AzureSubscription "青客仿真" -Current
	$VMs = Get-AzureVM
	foreach ($VM in $VMs)
	{	
		if ($VM.PowerState -eq "Started")
		{
			#Write-Output ($VM.InstanceName + " is already stopped")
		}else
		{
			$poweron=0
			foreach ($name in $names)
			{
				if ($VM.Name -eq $name){
					$poweron=1;
				}
			}
			if ($poweron -eq 1){
				$StartRtn = Start-AzureVM -Name $VM.Name -ServiceName $VM.ServiceName -ErrorAction Continue
				if ($StartRtn.OperationStatus -ne 'Succeeded')
				{
					Write-Output ($(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')+" "+$VM.InstanceName + " failed to start") >> logs\poweron.txt
				}
				else
				{
					# The VM stopped, so send notice
					$sql = "update azurevm set opened=0,state=1 where name='"+$VM.InstanceName+"'";
					$command = New-Object MySql.Data.MySqlClient.MySqlCommand($sql, $connection)
					$command.ExecuteNonQuery()
					Write-Output ($(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')+" "+$VM.InstanceName + " has been started") >> logs\poweron.txt
				}
				
			}
			
		}
	
	}
	
	
}

#关机判断
$sql="SELECT name FROM azurevm where closed=1"
$command = New-Object MySql.Data.MySqlClient.MySqlCommand($sql, $connection)
$dataAdapter = New-Object MySql.Data.MySqlClient.MySqlDataAdapter($command)
$ds = New-Object System.Data.DataSet
$closecount = $dataAdapter.Fill($ds)

if ($closecount -ge 1){
	
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
	
	
	#关闭测试
	Select-AzureSubscription "青客测试" -Current
	$VMs = Get-AzureVM
	foreach ($VM in $VMs)
	{	
		if ($VM.PowerState -eq "Stopped")
		{
			# The VM is already Stopped, so send notice
			#Write-Output ($VM.InstanceName + " is already stopped")
		}else
		{
			$shutdown=0
			foreach ($name in $names)
			{
				if ($VM.Name -eq $name){
					$shutdown=1;
				}
			}
			if ($shutdown -eq 1){
				$StopRtn = Stop-AzureVM -Name $VM.Name -ServiceName $VM.ServiceName -Force -ErrorAction Continue
				if ($StopRtn.OperationStatus -ne 'Succeeded')
				{
					# The VM failed to stop, so send notice
					Write-Output ($(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')+" "+$VM.InstanceName + " failed to stop") >> logs\poweroff.txt
				}
				else
				{
					# The VM stopped, so send notice
					$sql = "update azurevm set state=0,closed=0 where name='"+$VM.InstanceName+"'";
					$command = New-Object MySql.Data.MySqlClient.MySqlCommand($sql, $connection)
					$command.ExecuteNonQuery()
					Write-Output ($(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')+" "+$VM.InstanceName + " has been stopped") >> logs\poweroff.txt
				}
			}
			
		}
	
	}
	#关闭仿真
	Select-AzureSubscription "青客仿真" -Current
	$VMs = Get-AzureVM
	foreach ($VM in $VMs)
	{	
		if ($VM.PowerState -eq "Stopped")
		{
			# The VM is already Stopped, so send notice
			#Write-Output ($VM.InstanceName + " is already stopped")
		}else
		{
			$shutdown=0
			foreach ($name in $names)
			{
				if ($VM.Name -eq $name){
					$shutdown=1;
				}
			}
			if ($shutdown -eq 1){
				$StopRtn = Stop-AzureVM -Name $VM.Name -ServiceName $VM.ServiceName -Force -ErrorAction Continue
				if ($StopRtn.OperationStatus -ne 'Succeeded')
				{
					# The VM failed to stop, so send notice
					Write-Output ($(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')+" "+$VM.InstanceName + " failed to stop") >> logs\poweroff.txt
				}
				else
				{
					# The VM stopped, so send notice
					$sql = "update azurevm set state=0,closed=0 where name='"+$VM.InstanceName+"'";
					$command = New-Object MySql.Data.MySqlClient.MySqlCommand($sql, $connection)
					$command.ExecuteNonQuery()
					Write-Output ($(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')+" "+$VM.InstanceName + " has been stopped") >> logs\poweroff.txt
				}
			}
			
		}
	
	}







}






$connection.Close()
