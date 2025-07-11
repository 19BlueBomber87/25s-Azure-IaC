# https://learn.microsoft.com/en-us/training/modules/describe-azure-compute-networking-services/9-exercise-configure-network-access
# az vm list
# az vm list-ip-addresses
# az group list --output table
# az group list --query '[].{Name:name}' -o table   
# https://az-vm-image.info/
#################################################
#1 - Configure Linux VM with IaC
#################################################
$ResourceGroup1 = "azfund01"
$location = "WestUS2"
$vmName = "ubuntu-web-01"

az group create -n $ResourceGroup1 -l $location
#new VM
az vm create --resource-group $ResourceGroup1  --name $vmName --public-ip-sku Standard --image Ubuntu2204  --admin-username webadmin01 --admin-password "P@ssw0rd2025!" --generate-ssh-keys --nsg-rule NONE

#Configure web server 
az vm extension set --resource-group $ResourceGroup1 --vm-name $vmName --name customScript --publisher Microsoft.Azure.Extensions --version 2.1  --settings '{"fileUris":["https://raw.githubusercontent.com/19BlueBomber87/25s-Azure-IaC/refs/heads/main/akWildConfig.sh"]}' --protected-settings '{"commandToExecute": "./akWildConfig.sh"}'

#get public IP of VM
$IPADDRESS="$(az vm list-ip-addresses --resource-group $ResourceGroup1 --name $vmName --query "[].virtualMachine.network.publicIpAddresses[*].ipAddress" --output tsv)"

# Define nsg name -> nsg created during az vm create command.   
$vmNSG = az network nsg list --resource-group $ResourceGroup1 --query '[].name' --output tsv

#shows open ports
az network nsg rule list --resource-group $ResourceGroup1 --nsg-name $vmNSG --query '[].{Name:name, Priority:priority, Port:destinationPortRange, Access:access}' --output table

#create Rule
az network nsg rule create --resource-group $ResourceGroup1 --nsg-name $vmNSG --name allow-http --protocol tcp --priority 100 --destination-port-range 80 --access Allow
az network nsg rule create --resource-group $ResourceGroup1 --nsg-name $vmNSG --name yahoo-allow-SSH --protocol tcp --priority 101 --destination-port-range 22 --access Allow

#verify
az network nsg rule list --resource-group $ResourceGroup1 --nsg-name $vmNSG --query '[].{Name:name, Priority:priority, Port:destinationPortRange, Access:access}' --output table

#this now works, so does the web browser

curl --connect-timeout 5 http://$IPADDRESS
$IPADDRESS
#ip
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
    $vmName = "kali"
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


if($vmName -eq "kali"){
    Write-Verbose -Message "Kali-Linux VM found!  Running IaC config script <@:D" -Verbose *>&1
    az vm extension set --resource-group $ResourceGroupMixedVm --vm-name $vmName --name customScript --publisher Microsoft.Azure.Extensions --version 2.1   --settings '{"fileUris":["https://raw.githubusercontent.com/19BlueBomber87/25s-Azure-IaC/refs/heads/main/kaliConfig.sh"]}' --protected-settings '{"commandToExecute": "./kaliConfig.sh"}'
}

if($vmName -eq "win2019-01"){
    Write-Verbose -Message "Windows Server VM found!  Configuring IIS <@:D" -Verbose *>&1
    az network nsg rule create --resource-group $ResourceGroupMixedVm --nsg-name $vmNSG --name allow-http --protocol tcp --priority 111 --destination-port-range 80 --access Allow
    Set-AzVMExtension -ResourceGroupName $ResourceGroupMixedVm -ExtensionName "IIS" -VMName $vmName -Location "WestUS2" -Publisher Microsoft.Compute -ExtensionType CustomScriptExtension -TypeHandlerVersion 1.8 -SettingString '{"commandToExecute":"powershell Install-WindowsFeature Web-Server -IncludeManagementTools;mkdir C:\\temp\\;Invoke-WebRequest -Uri https://raw.githubusercontent.com/19BlueBomber87/25s-Azure-IaC/refs/heads/main/pic4web_IaC.ps1 -OutFile C:\\temp\\yahoo.ps1;C:\\temp\\yahoo.ps1 "}' -Verbose *>&1
}

#verify
az network nsg rule list --resource-group $ResourceGroupMixedVm --nsg-name $vmNSG --query '[].{Name:name, Priority:priority, Port:destinationPortRange, Access:access}' --output table

$IPADDRESS="$(az vm list-ip-addresses --resource-group $ResourceGroupMixedVm --name $vmName --query "[].virtualMachine.network.publicIpAddresses[*].ipAddress" --output tsv)"
$IPADDRESS
$z += 1


Write-Verbose -Message "$vmName and resources have been created! on $(Get-Date)"  -Verbose *>&1

}#end of foeach loop

#################################################
#4-Docker
#################################################

#docker VM
az group create -n dockerHostGroup -l WestUS2
az vm create --resource-group dockerHostGroup --name dockerHost --public-ip-sku Standard --image "Win2022Datacenter" --vnet-address-prefix 10.70.70.0/16 --subnet-address-prefix 10.70.70.0/24  --admin-username admin01 --admin-password "P@ssw0rd2025!" --size 'Standard_D2s_v3'--generate-ssh-keys  --accept-term 
Set-AzVMExtension -ResourceGroupName dockerHostGroup -ExtensionName "docker" -VMName dockerHost -Location "WestUS2" -Publisher Microsoft.Compute -ExtensionType CustomScriptExtension -TypeHandlerVersion 1.8 -SettingString '{"commandToExecute":"powershell Install-WindowsFeature Hyper-V -IncludeManagementTools;Install-WindowsFeature Containers;shutdown /r /f /t 0"}' -Verbose *>&1

# The following SKU Family VMs are some of the sizes capable of nested virtualization. These SKUs are hyper-threaded, nested capable VMs--> as of 2025
# D_v3
# Ds_v3
# E_v3
# Es_v3
# F2s_v2-F72s_v2
# M
#SETUP 
#set expiermental to True and Use System Settings

#Switch Dameon - Builders
& "C:\Program Files\Docker\Docker\DockerCli.exe" -SwitchDaemon
#finds pulled immages where 16f97fcf4440 is image id and -f is force
docker images
#remove image
docker image rm 16f97fcf4440 -f


#search Dcoker Hub
docker search nginx
docker search nginx --filter "is-official=true"
docker search nginx --filter "stars=50"
docker search --format "{{.Name}}: {{.StarCount}}" nginx


##pull 2022 and 2019 server core and Nano images
docker pull mcr.microsoft.com/windows/nanoserver:ltsc2022
docker pull mcr.microsoft.com/windows/servercore:ltsc2019
docker pull mcr.microsoft.com/windows/servercore:ltsc2022




#Create Container from Image.  The -it parameter command and using powershell is a way to keep the container running
docker run --name SetIISRole -it mcr.microsoft.com/windows/servercore:ltsc2022 powershell
docker ps -a

#Run inside container before commit
Install-WindowsFeature -Name Web-Server -Verbose *>&1;shutdown /s /f /t 0

#restart container and check role is installed
docker start "<ContainerID>"
docker exec powershell -c "Get-WindowsFeature -Name Web-Server" 


#The docker commit command commits the changes you made to a container to a new container image.
dcoker ps -a
docker commit "<ContainerID>" yahoo/testingimage:version1

#Create Container with IIS Role
docker images
docker run --name IIS-SVR1 -it "<imageID>" powershell







docker exec "<ContainerID>" ipconfig
docker exec "<ContainerID>" powershell -c "& c:\temp\yahoo.ps1"
 docker exec "<ContainerID>"powershell -c "dir C:\temp"
  docker exec "<ContainerID>" powershell -c "& C:\temp\yahoo.ps1"
  docker exec "<ContainerID>" powershell -c "mkdir C:\\temp\\;Invoke-WebRequest -Uri https://raw.githubusercontent.com/19BlueBomber87/25s-Azure-IaC/refs/heads/main/pic4web_IaC.ps1 -OutFile C:\\temp\\yahoo.ps1;& C:\\temp\\yahoo.ps1 "

mkdir C:\\temp\\;Invoke-WebRequest -Uri https://raw.githubusercontent.com/19BlueBomber87/25s-Azure-IaC/refs/heads/main/pic4web_IaC.ps1 -OutFile C:\\temp\\yahoo.ps1;
mkdir C:\\temp\\;Invoke-WebRequest -Uri https://raw.githubusercontent.com/19BlueBomber87/25s-Azure-IaC/refs/heads/main/pic4web_IaC.ps1 -OutFile C:\\temp\\yahoo.ps1;& C:\\temp\\yahoo.ps1 


docker network ls
docker network inspect "<NetworkID>"



docker run -it --isolation=process mcr.microsoft.com/windows/servercore:ltsc2019 powershell
docker run -it --isolation=hyperv mcr.microsoft.com/windows/servercore:ltsc2019 powershell


#ping rule etup on host, applies to container-Run command below on host to ping continer
netsh advfirewall firewall add rule name="ICMP Allow incoming V4 echo request" protocol="icmpv4:8,any" dir=in action=allow 


#Stop container by ID
docker stop "<ContainerID>"

#Start container by ID.  
docker start "<ContainerID>"
# -i interactive
docker start -i "<ContainerID>"
#remove container by ID
docker rm "<ContainerID>"


docker restart $(docker ps -q)

########################################################################
#_remove all resources
########################################################################
# Remove Lab 1
az group delete --name "azfund01" --yes

# Remove Lab 2
foreach($x in 2..5){
    Write-Verbose -Message "$x" -Verbose *>&1
    az group delete --name azfund0$x-Server2022 --yes
}

# Remove Lab3
az group delete --name "azfund06-MixedVms" --yes
#remove Lab4
az group delete --name "dockerHostGroup" --yes

##########################################################################
# vCPU, Size and Region Quotas
##########################################################################
# https://learn.microsoft.com/en-us/azure/virtual-machines/quotas?tabs=cli

# az vm list-usage --location "WestUS2" -o table
# az vm list-sizes --location "WestUS2" 
# az vm list-skus --location "WestUS2" 
# az vm list-sizes --location "WestUS2" --query '[].{name:name}' -o table
# az vm list-sizes --location "WestUS2" --query  "[?contains(name,'B')].{name:name}" -o table 
# az vm list-sizes --location "WestUS2" --query  "[?contains(name,'B2s')].{name:name}" -o 'table'

# ########################################################################
# # Find and Publishers and Test VM Images
# ########################################################################
# #Every image, take time to compile
# az vm image list --all --query '[].{urnAlias:urnAlias, Publisher:publisher, Offer:offer, Sku:sku, Urn:urn, Architecture:architecture}' --output table
# az vm image list --all --publisher Canonical  --query '[].{urnAlias:urnAlias, Publisher:publisher, Offer:offer, Sku:sku, Urn:urn, Architecture:architecture}' --output table
# az vm image list --all --publisher MicrosoftWindowsServer --query '[].{urnAlias:urnAlias, Publisher:publisher, Offer:offer, Sku:sku, Urn:urn, Architecture:architecture}' --output table

# #quick Search
# az vm image list --query '[].{urnAlias:urnAlias, Publisher:publisher, Offer:offer, Sku:sku, Urn:urn, Architecture:architecture}' --output table
# azfund01az vm image list --publisher Canonical  --query '[].{urnAlias:urnAlias, Publisher:publisher, Offer:offer, Sku:sku, Urn:urn, Architecture:architecture}' --output table
# az vm image list --publisher MicrosoftWindowsServer --query '[].{urnAlias:urnAlias, Publisher:publisher, Offer:offer, Sku:sku, Urn:urn, Architecture:architecture}' --output table

# #find Publishers
# az vm image list-publishers -l westus2 --query 'sort_by([].{Name:name}, &Name)' -o table | more

# #find images by publishers
# az vm image list-publishers -l westus2 --query "[?contains(name,'kali')].{Name: name}" -o table
# az vm image list-publishers -l westus2 --query "[?contains(name,'SUSE')].{Name: name}" -o table
# az vm image list-publishers -l westus2 --query "[?contains(name,'Windows')].{Name: name}" -o table

# #returns all, takes a few moments to run
# az vm image list --all --query '[].{urnAlias:urnAlias, Publisher:publisher, Offer:offer, Sku:sku, Urn:urn, Architecture:architecture}' --output table

# #list all images by MicrosoftWindowsServer
# az vm image list --all --publisher MicrosoftWindowsServer --query '[].{urnAlias:urnAlias, Publisher:publisher, Offer:offer, Sku:sku, Urn:urn, Architecture:architecture}' --output table

# az vm image list --all --publisher MicrosoftWindowsServer --query '[].{urnAlias:urnAlias, Publisher:publisher, Offer:offer, Sku:sku, Urn:urn, Architecture:architecture}' --output table
# az vm image list --all --publisher Canonical --query '[].{urnAlias:urnAlias, Publisher:publisher, Offer:offer, Sku:sku, Urn:urn, Architecture:architecture}' --output table

# #filter Results
# az vm image list-publishers -l westus2 --query "[?name=='Microsoft.AksArc']"
# az vm image list --publisher MicrosoftWindowsServer --query "[?contains(urnAlias,'2012')].{urnAlias: urnAlias}" --output table

# az vm image list --all --publisher SUSE --query '[].{urnAlias:urnAlias, Publisher:publisher, Offer:offer, Sku:sku, Urn:urn, Architecture:architecture}' --output table
# az vm image list --all --publisher "kali-linux" --query '[].{urnAlias:urnAlias, Publisher:publisher, Offer:offer, Sku:sku, Urn:urn, Architecture:architecture}' --output table

# az vm image list --all --publisher "MicrosoftWindowsDesktop" --query '[].{urnAlias:urnAlias, Publisher:publisher, Offer:offer, Sku:sku, Urn:urn, Architecture:architecture}' --output table
# ###############################################################
# #################################################

# az group create -n yahoo -l WestUS2

# az vm create --resource-group yahoo  --name ubuntu2024 --public-ip-sku Standard --image "Canonical:ubuntu-24_04-lts:server:latest" --admin-username funduser01 --admin-password "P@ssw0rd2025!" --generate-ssh-keys

# az vm create --resource-group yahoo  --name win2019 --public-ip-sku Standard --image "Win2019Datacenter" --admin-username funduser01 --admin-password "P@ssw0rd2025!" --generate-ssh-keys

# az vm create --resource-group yahoo  --name Suse --public-ip-sku Standard --image "SUSE:sles-15-sp5:gen2:latest" --admin-username funduser01 --admin-password "P@ssw0rd2025!" --generate-ssh-keys

# az vm create --resource-group yahoo  --name win11 --public-ip-sku Standard --image "MicrosoftWindowsDesktop:office-365:win11-23h2-avd-m365:22631.5039.250311" --admin-username funduser01 --admin-password "P@ssw0rd2025!" --generate-ssh-keys


# az vm image accept-terms --urn "kali-linux:kali:kali-2024-4:2024.4.1"
# az vm image terms show --urn "kali-linux:kali:kali-2024-4:2024.4.1"

# az vm create --resource-group yahoo  --name "Kali" --public-ip-sku Standard --image "kali-linux:kali:kali-2024-4:2024.4.1" --admin-username funduser01 --admin-password "P@ssw0rd2025!" --generate-ssh-keys  --accept-term 


# az ssh vm --resource-group yahoo --vm-name Kali --local-user funduser01

# az vm extension set --resource-group yahoo --vm-name kali --name customScript --publisher Microsoft.Azure.Extensions --version 2.1   --settings '{"fileUris":["https://raw.githubusercontent.com/19BlueBomber87/25s-Azure-IaC/refs/heads/main/kaliConfig.sh"]}' --protected-settings '{"commandToExecute": "./kaliConfig.sh"}'

# #END


# (curl -Uri http://4.155.194.5/ | select content).content

# https://www.geeksforgeeks.org/linux-unix/top-30-basic-nmap-commands-for-beginners/
# https://www.geeksforgeeks.org/ethical-hacking/nmap-cheat-sheet/

# nmap 172.40.0.*
# 172.40.0.0/24
# # nmap -p 54-111 192.168.0.0/24


