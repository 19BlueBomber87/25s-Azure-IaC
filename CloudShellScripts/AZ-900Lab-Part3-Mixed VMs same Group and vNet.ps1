#################################################
#3-Many VMs Same Group
#################################################

#Accept Kali Terms
az vm image accept-terms --urn "kali-linux:kali:kali-2024-4:2024.4.1"
az vm image terms show --urn "kali-linux:kali:kali-2024-4:2024.4.1"

#Create group
$ResourceGroupMixedVm = "azfund06-MixedVms"
#
az group create -n $ResourceGroupMixedVm -l "WestUS2"

#Create network
$networkname = "MixedVmVnet"
$subnetname = "MixedVMSubnet"
az network vnet create -g $ResourceGroupMixedVm -n $networkname  --address-prefix 172.40.0.0/16 --subnet-name $subnetname --subnet-prefixes 172.40.0.0/24

#Define variables
$image1 = "Win2019Datacenter"
$image2 = "Canonical:ubuntu-24_04-lts:server:latest"
$image3 = "SUSE:sles-15-sp5:gen2:latest"
$image4 = "kali-linux:kali:kali-2024-4:2024.4.1"
$image5 = "MicrosoftWindowsDesktop:office-365:win11-23h2-avd-m365:22631.5039.250311"
$images = @($image1, $image2 , $image3, $image4, $image5)

$z=1

#Start loop
foreach($image in $images){

Write-Verbose -Message "<@:D $image" -Verbose *>&1

#Define vmName variable by image name
if($image -eq "Win2019Datacenter"){
    $vmName = "win2019-01"
}elseif($image -eq "Canonical:ubuntu-24_04-lts:server:latest"){
    $vmName = "ubuntu-web-02"
}elseif($image -eq "SUSE:sles-15-sp5:gen2:latest"){
    $vmName = "SUSE-01"
}elseif($image -eq "kali-linux:kali:kali-2024-4:2024.4.1"){
    $vmName = "kali-01"
}elseif($image -eq "MicrosoftWindowsDesktop:office-365:win11-23h2-avd-m365:22631.5039.250311"){
    $vmName = "win11-01"
}else{
Write-Verbose -Message "Error" -Verbose *>&1
}

#NSG set in command
az vm create --resource-group $ResourceGroupMixedVm --name $vmName --public-ip-sku Standard --image $image --vnet-name $networkname  --subnet $subnetname --admin-username admin0$z --admin-password "P@ssw0rd2025!" --generate-ssh-keys --nsg-rule NONE  --accept-term 


# Define nsg name -> nsg created during az vm create command.   
$vmNSG = $vmname+"NSG"

az network nsg rule create --resource-group $ResourceGroupMixedVm --nsg-name $vmNSG --name yahoo-allow-RDP --protocol tcp --priority 101 --destination-port-range 3389 --access Allow
az network nsg rule create --resource-group $ResourceGroupMixedVm --nsg-name $vmNSG --name yahoo-allow-SSH --protocol tcp --priority 102 --destination-port-range 22 --access Allow



if($vmName -eq "ubuntu-web-02"){
    Write-Verbose -Message "Ubuntu VM found!  Running IaC script to configure website <@:D" -Verbose *>&1
    az vm extension set --resource-group $ResourceGroupMixedVm --vm-name $vmName --name customScript --publisher Microsoft.Azure.Extensions --version 2.1   --settings '{"fileUris":["https://raw.githubusercontent.com/19BlueBomber87/25s-Azure-IaC/refs/heads/main/akWildConfig.sh"]}' --protected-settings '{"commandToExecute": "./akWildConfig.sh"}'
    az network nsg rule create --resource-group $ResourceGroupMixedVm --nsg-name $vmNSG --name allow-http --protocol tcp --priority 111 --destination-port-range 80 --access Allow

}


if($vmName -eq "kali-01"){
    Write-Verbose -Message "Kali-Linux VM found!  Running IaC config script <@:D" -Verbose *>&1
    az vm extension set --resource-group $ResourceGroupMixedVm --vm-name $vmName --name customScript --publisher Microsoft.Azure.Extensions --version 2.1   --settings '{"fileUris":["https://raw.githubusercontent.com/19BlueBomber87/25s-Azure-IaC/refs/heads/main/kaliConfig.sh"]}' --protected-settings '{"commandToExecute": "./kaliConfig.sh"}'
}

if($vmName -eq "win2019-01"){
    Write-Verbose -Message "Windows Server VM found!  Configuring IIS <@:D" -Verbose *>&1
    az network nsg rule create --resource-group $ResourceGroupMixedVm --nsg-name $vmNSG --name allow-http --protocol tcp --priority 111 --destination-port-range 80 --access Allow
    Set-AzVMExtension -ResourceGroupName $ResourceGroupMixedVm -ExtensionName "IIS" -VMName $vmName -Location "WestUS2" -Publisher Microsoft.Compute -ExtensionType CustomScriptExtension -TypeHandlerVersion 1.8 -SettingString '{"commandToExecute":"powershell Install-WindowsFeature Web-Server -IncludeManagementTools;Invoke-WebRequest -Uri https://raw.githubusercontent.com/19BlueBomber87/25s-Azure-IaC/refs/heads/main/html/azurehome.html -OutFile C:\\inetpub\\wwwroot\\Default.htm;mkdir C:\\temp\\;Invoke-WebRequest -Uri https://raw.githubusercontent.com/19BlueBomber87/25s-Azure-IaC/refs/heads/main/pic4web_IaC.ps1 -OutFile C:\\temp\\yahoo.ps1;C:\\temp\\yahoo.ps1 "}' -Verbose *>&1
}

#verify
az network nsg rule list --resource-group $ResourceGroupMixedVm --nsg-name $vmNSG --query '[].{Name:name, Priority:priority, Port:destinationPortRange, Access:access}' --output table

$IPADDRESS="$(az vm list-ip-addresses --resource-group $ResourceGroupMixedVm --name $vmName --query "[].virtualMachine.network.publicIpAddresses[*].ipAddress" --output tsv)"
$IPADDRESS
$z += 1


Write-Verbose -Message "$vmName and resources have been created! on $(Get-Date)"  -Verbose *>&1

}#end of foeach loop
