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