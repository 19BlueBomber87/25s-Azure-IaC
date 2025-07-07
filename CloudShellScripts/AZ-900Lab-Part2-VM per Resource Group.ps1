#################################################
#2- VM per Resource Group
#################################################

####### Fun Review TEST #############
foreach($x in 1..7){
Write-Verbose -Message "<@:D Loop $($x) running.  X Variable is a $($x.gettype()) " -Verbose *>&1
$vmName = "fundvm0$x-ms2022"
Write-Verbose -Message "$VmName`nvmName Variable is a $($vmName.gettype())" -Verbose *>&1
}#end
####### TEST #############

#Sart loop
foreach($x in 1..4){
#Name resource at run time
$ResourceGroupWS = "azfund0$($x+1)-Server2022"

az group create -n $ResourceGroupWS -l "WestUS2"

Write-Verbose -Message "<@:D Loop $($x) running-$ResourceGroupWS" -Verbose *>&1

#Name VM at Runtime
$vmName = "WIN-SVR22-0$x"

$image = "Win2022Datacenter"

#Increment octet for each network
$octet =15 + $X 
az vm create --resource-group $ResourceGroupWS  --name $vmName --public-ip-sku Standard --image $image --vnet-address-prefix 172.$octet.0.0/16 --subnet-address-prefix 172.$octet.0.0/24  --admin-username windowsadmin0$x --admin-password "P@ssw0rd2025!" --size 'Standard_B2ms' --generate-ssh-keys --nsg-rule NONE

# Define nsg name -> nsg created during az vm create command.   
$vmNSG = $vmname+"NSG"

#create Rule
az network nsg rule create --resource-group $ResourceGroupWS --nsg-name $vmNSG --name yahoo-allow-RDP --protocol tcp --priority 100 --destination-port-range 3389 --access Allow
az network nsg rule create --resource-group $ResourceGroupWS --nsg-name $vmNSG --name yahoo-allow-SSH --protocol tcp --priority 101 --destination-port-range 22 --access Allow

#verify
az network nsg rule list --resource-group $ResourceGroupWS  --nsg-name $vmNSG --query '[].{Name:name, Priority:priority, Port:destinationPortRange, Access:access}' --output table

#Enable PS Remoting
Set-AzVMExtension -ResourceGroupName $ResourceGroupWS -ExtensionName "PSRemoting" -VMName $vmName -Location "WestUS2" -Publisher Microsoft.Compute -ExtensionType CustomScriptExtension -TypeHandlerVersion 1.8 -SettingString '{"commandToExecute":"powershell winrm quickconfig -quiet;Enable-PSRemoting -Force;Set-NetFirewallRule -Name WINRM-HTTP-In-TCP -RemoteAddress Any -Profile Domain,Public,Private;Set-Item WSMan:\\localhost\\Client\\TrustedHosts -Value * -Force"}' -Verbose *>&1

#get public IP of VM
$IPADDRESS="$(az vm list-ip-addresses --resource-group $ResourceGroupWS --name $vmName --query "[].virtualMachine.network.publicIpAddresses[*].ipAddress" --output tsv)"
Write-Verbose -Message "$vmName and resources have been created! on $(Get-Date)"  -Verbose *>&1
$IPADDRESS
}#end of foeach loop

#tests to run
netsh advfirewall firewall add rule name="ICMP Allow incoming V4 echo request" protocol="icmpv4:8,any" dir=in action=allow
Get-NetFirewallRule -Name WINRM-HTTP-In-TCP
Get-Item WSMan:\localhost\Client\TrustedHosts