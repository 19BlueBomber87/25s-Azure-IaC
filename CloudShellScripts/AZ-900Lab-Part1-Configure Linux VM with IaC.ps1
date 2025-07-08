# https://learn.microsoft.com/en-us/training/modules/describe-azure-compute-networking-services/9-exercise-configure-network-access
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
