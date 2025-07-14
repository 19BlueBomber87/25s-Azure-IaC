[25s-Azue-IaC][Full Video]
https://youtu.be/XL8oJziFtNo

[25s-Azue-IaC][Lab01]
https://youtu.be/yTHhuZnadaw
In this video, I celebrate achieving my first Microsoft certification, the AZ-900 Azure Fundamentals, which introduces Microsoft's Azure cloud computing platform. I walk you through a lab where I create a Linux virtual machine using the Azure CLI and set up a custom script to turn it into an Nginx web server. I explain the commands and parameters involved, including creating a resource group and configuring network security rules. I encourage you to check out the code on my GitHub repository under the 25s-azure-IaC repository. 

[25s-Azue-IaC][Lab02]
https://youtu.be/X4Piytd56is
In this video, I walk you through the process of creating four Windows Server 2022 Azure VMs and configuring them for PowerShell remoting using a “for each” loop. We iterate through the numbers one to four to name our resource groups and virtual machines, ensuring each has a unique identifier. I demonstrate how to set up the virtual networks and apply network security group rules for RDP and SSH access. We establish network peering between the VNets to enable connectivity. Please follow along and replicate the steps in your own Azure environment to set up your servers and test the PS remoting functionality!

[25s-Azue-IaC][Lab03]
https://youtu.be/1VOTgTrGXME
In this lab, I demonstrate how to create five virtual machines from different images and place them all in the same resource group while connecting them to the same vNet. A variety of VM images including Windows Server 2019, Windows 11, Ubuntu, OpenSUSE, and Kali Linux are used. I walk through the configuration process for each VM, highlighting specific setups like installing web server roles and pen-testing tools. I also showcase how to check open ports and access the web pages for each server. Please ensure you follow along with the script and replicate these steps in your own environment.

[25s-Azue-IaC][Lab04]
https://youtu.be/mEJp6S2Zn3Q
This video focuses on using Docker to run Windows Server 2022 Core containers.   We set up a virtual machine, install the Docker runtime, and create multiple instances of a Windows Server 2022 Core containers to run web pages. I demonstrate how to install the necessary features, commit changes to create new images, and efficiently deploy ten containers. I encourage you to follow along and replicate the steps to gain hands-on experience with containers.

[25s-Azue-IaC][Peerings]
https://youtu.be/vC7Xdcj86Rk
In this video, I walk you through the process of setting up VNet peering between our vNets.  We successfully establish peerings to access our Linux and Windows web servers using their private IP addresses instead of their public ones. I also demonstrate how to ensure that the Windows servers can respond to pings. Please make sure to follow along and replicate these steps in your own environment. 

[25s-Azue-IaC][Quotas and Finding Images]
https://youtu.be/hkf2MUyjSQU
In this video, I walk through some challenges I faced while creating the labs, particularly regarding quota limits for virtual machine vCPUs in Azure. My regional vCPUs quota was set to 20, and after submitting a request through the Azure portal, I successfully increased it to 25 within minutes. I also share tips on finding images using the Azure CLI, including how to format queries for efficient searches. I encourage viewers to familiarize themselves with these commands and the Azure portal to streamline their own lab setups. Please take note of the specific commands and processes I demonstrated to enhance your experience.

[25s-Azue-IaC][Cleanup]
https://youtu.be/7jgTIk1DQaI
In this video I emphasize the importance of organizing your test objects within a resource group so that you can easily remove everything once you're done testing. I also demonstrate how to delete the resource groups both through the cloud shell and the Azure portal. By the end of this process, all resources from the labs will be deleted in about 5 minutes. I encourage you to try this approach to simplify your resource management.
