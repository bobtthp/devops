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
$sql="SELECT name FROM poweron where state=1"
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


Select-AzureSubscription "Microsoft Azure Enterprise ÊÔÓÃ°æ(Converted to EA)" -Current
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
				Write-Output ($(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')+" "+$VM.InstanceName + " has been started") >> logs\poweron.txt
			}
			
		}
		
	}

}

