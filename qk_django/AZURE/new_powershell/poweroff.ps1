param (
        [Parameter(Mandatory=$false)] 
        [String] $type
    )

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


if ($type -eq "all"){#关闭所有22点运行

	#关闭所有测试
	Select-AzureSubscription "青客测试" -Current
	$VMs = Get-AzureVM
	foreach ($VM in $VMs)
	{	
		if ($VM.PowerState -eq "Stopped")
		{
			#Write-Output ($VM.InstanceName + " is already stopped")
		}else
		{
			$StopRtn = Stop-AzureVM -Name $VM.Name -ServiceName $VM.ServiceName -Force -ErrorAction Continue
			if ($StopRtn.OperationStatus -ne 'Succeeded')
			{
				Write-Output ($(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')+" "+$VM.InstanceName + " failed to stop") >> logs\poweroff.txt
			}
			else
			{
				Write-Output ($(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')+" "+$VM.InstanceName + " has been stopped") >> logs\poweroff.txt
				$sql = "update azurevm set state=0,delayedoff=0,closed=0";
				$command = New-Object MySql.Data.MySqlClient.MySqlCommand($sql, $connection)
				$command.ExecuteNonQuery()
			}
		}
	}
	
	#关闭所有仿真
	Select-AzureSubscription "青客仿真" -Current
	$VMs = Get-AzureVM
	foreach ($VM in $VMs)
	{	
		if ($VM.PowerState -eq "Stopped")
		{
			#Write-Output ($VM.InstanceName + " is already stopped")
		}else
		{
			$StopRtn = Stop-AzureVM -Name $VM.Name -ServiceName $VM.ServiceName -Force -ErrorAction Continue
			if ($StopRtn.OperationStatus -ne 'Succeeded')
			{
				Write-Output ($(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')+" "+$VM.InstanceName + " failed to stop") >> logs\poweroff.txt
			}
			else
			{
				
				Write-Output ($(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')+" "+$VM.InstanceName + " has been stopped") >> logs\poweroff.txt
					#重置所有虚机状态
				$sql = "update azurevm set state=0,delayedoff=0,closed=0";
				$command = New-Object MySql.Data.MySqlClient.MySqlCommand($sql, $connection)
				$command.ExecuteNonQuery()
			}
		}
	}
	

	
}else{#19点执行
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
	
	
	#18点关闭未延时的
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
			$noshutdown=0
			foreach ($name in $names)
			{
				if ($VM.Name -eq $name){
					$noshutdown=1;
				}
			}
			if ($noshutdown -eq 1){
				Write-Output ($(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')+" "+$VM.InstanceName + " in no_poweroff list") >> logs\poweroff.txt
			}else{
				$StopRtn = Stop-AzureVM -Name $VM.Name -ServiceName $VM.ServiceName -Force -ErrorAction Continue
				if ($StopRtn.OperationStatus -ne 'Succeeded')
				{
					# The VM failed to stop, so send notice
					Write-Output ($(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')+" "+$VM.InstanceName + " failed to stop") >> logs\poweroff.txt
				}
				else
				{
					# The VM stopped, so send notice
					$sql = "update azurevm set state=0 where name='"+$VM.InstanceName+"'";
					$command = New-Object MySql.Data.MySqlClient.MySqlCommand($sql, $connection)
					$command.ExecuteNonQuery()
					Write-Output ($(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')+" "+$VM.InstanceName + " has been stopped") >> logs\poweroff.txt
				}
			}
			
		}
	
	}
	
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
			$noshutdown=0
			foreach ($name in $names)
			{
				if ($VM.Name -eq $name){
					$noshutdown=1;
				}
			}
			if ($noshutdown -eq 1){
				Write-Output ($(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')+" "+$VM.InstanceName + " in no_poweroff list") >> logs\poweroff.txt
			}else{
				$StopRtn = Stop-AzureVM -Name $VM.Name -ServiceName $VM.ServiceName -Force -ErrorAction Continue
				if ($StopRtn.OperationStatus -ne 'Succeeded')
				{
					# The VM failed to stop, so send notice
					Write-Output ($(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')+" "+$VM.InstanceName + " failed to stop") >> logs\poweroff.txt
				}
				else
				{
					# The VM stopped, so send notice
					$sql = "update azurevm set state=0 where name='"+$VM.InstanceName+"'";
					$command = New-Object MySql.Data.MySqlClient.MySqlCommand($sql, $connection)
					$command.ExecuteNonQuery()
					Write-Output ($(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')+" "+$VM.InstanceName + " has been stopped") >> logs\poweroff.txt
				}
			}
			
		}
	
	}
}

$connection.Close()

