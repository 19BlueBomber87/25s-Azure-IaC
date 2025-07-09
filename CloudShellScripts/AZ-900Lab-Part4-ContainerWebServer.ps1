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



#Run commmand creates container and start it

#runs once
docker run --name IIS mcr.microsoft.com/windows/nanoserver:ltsc2022 powershell

#runs interactive terminal at start up,
docker run --name IIS-roleSet -it mcr.microsoft.com/windows/servercore:ltsc2022 powershell

#The docker commit command commits the changes you made to a container to a new container image.
docker commit
docker commit a4e7b3c9ce97 yahoo/testingimage:version1
docker run --name IIS-SVR1 -it 93651bb541de powershell


#Stop container by ID
docker stop contianerID

#Start container by ID.  
docker start contianerID
# -i interactive
docker start -i contianerID
#remove container by ID
docker rm containerID

#networks ->https://docs.docker.com/engine/network/

#ping rule etup on host, applies to container-Run command below on host to ping continer
# netsh advfirewall firewall add rule name="ICMP Allow incoming V4 echo request" protocol="icmpv4:8,any" dir=in action=allow

docker network create -d bridge my-net

docker ps -a
docker run -it --isolation=process mcr.microsoft.com/windows/servercore:ltsc2019 powershell
docker run -it --isolation=hyperv mcr.microsoft.com/windows/servercore:ltsc2019 powershell

https://github.com/miccze/NanoServerImageGenerator/blob/master/NanoServerImageGenerator.psm1








docker exec a4e7b3c9ce97 ipconfig
docker exec a4e7b3c9ce97 "& c:\temp\yahoo.ps1"
 docker exec a4e7b3c9ce97 powershell -c "dir C:\temp"
  docker exec a4e7b3c9ce97 powershell -c "& C:\temp\yahoo.ps1"
  docker exec a4e7b3c9ce97 powershell -c "mkdir C:\\temp\\;Invoke-WebRequest -Uri https://raw.githubusercontent.com/19BlueBomber87/25s-Azure-IaC/refs/heads/main/pic4web_IaC.ps1 -OutFile C:\\temp\\yahoo.ps1;"