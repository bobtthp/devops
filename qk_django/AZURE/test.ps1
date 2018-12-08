Select-AzureSubscription "Çà¿Í·ÂÕæ" -Current
	$VMs = Get-AzureDisk
	foreach ($VM in $VMs)
	{	
		Write-Output($VM.AttachedTo.RoleName+'   '+$VM.OS);
		#Write-Output($VM.AttachedTo.RoleName+'   '+'https://'+$VM.MediaLink.Authority+'    '+$VM.MediaLink.AbsolutePath);
		#$VM.AttachedTo
		#if ($VM.PowerState -eq "Stopped")
		#
		#	$StopRtn = Stop-AzureVM -Name $VM.Name -ServiceName $VM.ServiceName -Force -ErrorAction Continue
    
	}
	#$VMs = Get-AzureStorageAccount
	#foreach ($VM in $VMs)
	#{	
	#	#Write-Output($VM.StorageAccountName);
	#	$ACS=Get-AzureStorageKey -storageaccountname $VM.StorageAccountName
	#	foreach ($AC in $ACS){
	#		Write-Output($VM.StorageAccountName+' '+$AC.Primary);
	#	}
	#	#$VM.AttachedTo
	#	#if ($VM.PowerState -eq "Stopped")
	#	#
	#	#	$StopRtn = Stop-AzureVM -Name $VM.Name -ServiceName $VM.ServiceName -Force -ErrorAction Continue
    #
	#}