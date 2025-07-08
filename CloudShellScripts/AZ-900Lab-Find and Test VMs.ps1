########################################################################
# Find and Publishers and Test VM Images
########################################################################
#Every image, take time to compile
az vm image list --all --query '[].{urnAlias:urnAlias, Publisher:publisher, Offer:offer, Sku:sku, Urn:urn, Architecture:architecture}' --output table
az vm image list --all --publisher Canonical  --query '[].{urnAlias:urnAlias, Publisher:publisher, Offer:offer, Sku:sku, Urn:urn, Architecture:architecture}' --output table
az vm image list --all --publisher MicrosoftWindowsServer --query '[].{urnAlias:urnAlias, Publisher:publisher, Offer:offer, Sku:sku, Urn:urn, Architecture:architecture}' --output table

#quick Search
az vm image list --query '[].{urnAlias:urnAlias, Publisher:publisher, Offer:offer, Sku:sku, Urn:urn, Architecture:architecture}' --output table
azfund01az vm image list --publisher Canonical  --query '[].{urnAlias:urnAlias, Publisher:publisher, Offer:offer, Sku:sku, Urn:urn, Architecture:architecture}' --output table
az vm image list --publisher MicrosoftWindowsServer --query '[].{urnAlias:urnAlias, Publisher:publisher, Offer:offer, Sku:sku, Urn:urn, Architecture:architecture}' --output table

#find Publishers
az vm image list-publishers -l westus2 --query 'sort_by([].{Name:name}, &Name)' -o table | more

#find images by publishers
az vm image list-publishers -l westus2 --query "[?contains(name,'kali')].{Name: name}" -o table
az vm image list-publishers -l westus2 --query "[?contains(name,'SUSE')].{Name: name}" -o table
az vm image list-publishers -l westus2 --query "[?contains(name,'Windows')].{Name: name}" -o table

#returns all, takes a few moments to run
az vm image list --all --query '[].{urnAlias:urnAlias, Publisher:publisher, Offer:offer, Sku:sku, Urn:urn, Architecture:architecture}' --output table

#list all images by MicrosoftWindowsServer
az vm image list --all --publisher MicrosoftWindowsServer --query '[].{urnAlias:urnAlias, Publisher:publisher, Offer:offer, Sku:sku, Urn:urn, Architecture:architecture}' --output table

az vm image list --all --publisher MicrosoftWindowsServer --query '[].{urnAlias:urnAlias, Publisher:publisher, Offer:offer, Sku:sku, Urn:urn, Architecture:architecture}' --output table
az vm image list --all --publisher Canonical --query '[].{urnAlias:urnAlias, Publisher:publisher, Offer:offer, Sku:sku, Urn:urn, Architecture:architecture}' --output table

#filter Results
az vm image list-publishers -l westus2 --query "[?name=='Microsoft.AksArc']"
az vm image list --publisher MicrosoftWindowsServer --query "[?contains(urnAlias,'2012')].{urnAlias: urnAlias}" --output table

az vm image list --all --publisher SUSE --query '[].{urnAlias:urnAlias, Publisher:publisher, Offer:offer, Sku:sku, Urn:urn, Architecture:architecture}' --output table
az vm image list --all --publisher "kali-linux" --query '[].{urnAlias:urnAlias, Publisher:publisher, Offer:offer, Sku:sku, Urn:urn, Architecture:architecture}' --output table

az vm image list --all --publisher "MicrosoftWindowsDesktop" --query '[].{urnAlias:urnAlias, Publisher:publisher, Offer:offer, Sku:sku, Urn:urn, Architecture:architecture}' --output table
###############################################################
#################################################

az group create -n yahoo -l WestUS2

az vm create --resource-group yahoo  --name ubuntu2024 --public-ip-sku Standard --image "Canonical:ubuntu-24_04-lts:server:latest" --admin-username funduser01 --admin-password "P@ssw0rd2025!" --generate-ssh-keys

az vm create --resource-group yahoo  --name win2019 --public-ip-sku Standard --image "Win2019Datacenter" --admin-username funduser01 --admin-password "P@ssw0rd2025!" --generate-ssh-keys

az vm create --resource-group yahoo  --name Suse --public-ip-sku Standard --image "SUSE:sles-15-sp5:gen2:latest" --admin-username funduser01 --admin-password "P@ssw0rd2025!" --generate-ssh-keys

az vm create --resource-group yahoo  --name win11 --public-ip-sku Standard --image "MicrosoftWindowsDesktop:office-365:win11-23h2-avd-m365:22631.5039.250311" --admin-username funduser01 --admin-password "P@ssw0rd2025!" --generate-ssh-keys


az vm image accept-terms --urn "kali-linux:kali:kali-2024-4:2024.4.1"
az vm image terms show --urn "kali-linux:kali:kali-2024-4:2024.4.1"

az vm create --resource-group yahoo  --name "Kali" --public-ip-sku Standard --image "kali-linux:kali:kali-2024-4:2024.4.1" --admin-username funduser01 --admin-password "P@ssw0rd2025!" --generate-ssh-keys  --accept-term 


az ssh vm --resource-group yahoo --vm-name Kali --local-user funduser01

az vm extension set --resource-group yahoo --vm-name kali --name customScript --publisher Microsoft.Azure.Extensions --version 2.1   --settings '{"fileUris":["https://raw.githubusercontent.com/19BlueBomber87/25s-Azure-IaC/refs/heads/main/kaliConfig.sh"]}' --protected-settings '{"commandToExecute": "./kaliConfig.sh"}'

#List VMs and Groups in a table format
az vm list
az vm list-ip-addresses
az group list --output table
az group list --query '[].{Name:name}' -o table   
#END
