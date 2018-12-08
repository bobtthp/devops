Select-AzureSubscription "Çà¿Í²âÊÔ" -Current
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

			}
		}
	}