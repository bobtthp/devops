
	#�رշ���
	Select-AzureSubscription "��ͷ���" -Current
	$VMs = Get-AzureVM
	foreach ($VM in $VMs)
	{	
		#$endproint=Get-AzureVM -ServiceName $VM.servicename -Name $VM.name |Get-AzureEndpoint
		#foreach ($ep in $endproint){
		#
		#	write-Output($VM.name+' '+$ep.name+' '+$ep.LocalPort+' '+$ep.port);
		#}
		write-Output($VM.name);
		#write-Output($endproint);
		#write-Output($VM.name+' '+$endproint.name+' '+$endproint.LocalPort+' '+$endproint.port);
	
	}

