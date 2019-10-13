# Lab 1 - Virtual Networks
 
## Before you Begin
If you are using a Microsoft Azure subscription that was provided to you by Microsoft, you using what is called sponsored Azure and that subscription is  limited to a specific set of Microsoft Azure regions. Please consistently use one of the following locations:
* East US
* South Central US
* West Europe
* Southeast Asia
* West US 2
* West Central US 

Otherwise you will receive an error in the portal if you select an unsupported region and attempt to build anything in Microsoft Azure.

## Lab Summary
You will complete four different labs on the following core elements of Azure Networking:
1) Virtual networks 
2) Load Balancing
3) Traffic Manager
4) Network Watcher

Each lab is a unique file on GitHub 

  
## Task 1 - Virtual Networks
In this lab you are going top create multiple virtual networks each with it's own virtual machine and subnet and then test connectivity across subnets and vnets.
### Create three virtual networks
1.	Log in to the Azure portal at https://portal.azure.com and 	*click on **+Create a resource***  on the upper left corner of the Azure portal.
2.	*Select **Networking***, and then *select **Virtual network***.
3.	Enter or select the following information, accept the defaults for the remaining settings, and then *select **Create***:

    Under **Basics**:
    - Resource Group: *Click **Create New*** and name it **RG-LAB-NETWORKING**
    - Name: **VNET01**
    - Region: *Choose a consistent and supported location*
    - *Click **Next***

    Under **IP Addresses**:
    - Address Space: **10.1.0.0/16**
    - *Click the **default*** name for the subnet to open its properties:
      - Subnet Name: **SUBNET01**
      - Subnet address range: **10.1.1.0/24** 
      - *Click **Save***
    - *Click **Review + create***
    - *Click **Create***


Repeat the steps above for VNET02:
- Resource Group: **RG-LAB-NETWORKING**
- Name: **VNET02**
- Region: *Choose a consistent and supported location*
- Address Space: **10.2.0.0/16**
- Subnet Name: **SUBNET02**
- Subnet address range: **10.2.2.0/24**

Repeat the steps above for VNET03:
- Resource Group: **RG-LAB-NETWORKING**
- Name: **VNET03**
- Region: *Choose a consistent and supported location*
- Address Space: **10.3.0.0/16**
- Subnet Name: **SUBNET03**
- Subnet address range: **10.3.3.0/24**


 
## Task 2 - Create three virtual machines

1.	*Select **+ Create a resource*** found on the upper left corner of the Azure portal.
2.	*Select **Windows Server 2016 Datacenter*** under *Get Started.  NOTE: You may need to search for the gallery image if you do not see it listed under the popular section.*
3.	Enter or select the following information, accept the defaults for the remaining settings:

    Under **Basics**:
    - Resource Group: select **RG-LAB-NETWORKING**
    - Name: **VMWIN01**
    - Region: *Choose a consistent and supported Region*
    - Size: *Change to **B2ms***
    - Username: 'Goose'
    - Password: 'then33d4sp33d!'
    - Confirm Password: 'then33d4sp33d!'
    - Public inbound ports: *Select **Allow selected ports***  
      - *Check **RDP, 3389***
    - *Select **Next:Disks***
    - Click **Next: Networking**

4. 	Under **Networking:**
   - Set the virtual network to **VNET01**
   - *Select **Next: Management***

5.	Under **Management** 
   - Under **Diagnostics storage account** *click **Create new*** 
   - Enter **savmdiag01*<initials>***, *(eg savmdiag01jrl): You may need to append an additional number if you receive an error stating the name is already taken*  
   - *Click **OK***
   - *Click **Next: Guest config**
6.	*Click **Review + create**
7.	Once validation passes *click **Create***

## Task 3 - Create the second VM
Complete the previous steps but use the following information:
- Resource Group: **RG-LAB-NETWORKING**
- Name: **VMWIN02**
- Region: *Choose a consistent supported Region*
- Size: Change to **B2ms**
- Username: 'Goose'
- Password: 'then33d4sp33d!'
- Confirm Password: 'then33d4sp33d!'
- Public inbound ports: Open RDP, 3389
- Set the virtual network to **VNET02** 
- Under **Diagnostic storage account** use the previously created Diagnostics storage account


## Task 4 - Create the third VM
Complete the previous steps but use the following information:
- Resource Group: **RG-LAB-NETWORKING**
- Name: **VMWIN03**
- Region: *Choose a consistent supported Region*
- Size: Change to **B2ms**
- Username: 'Goose'
- Password: 'then33d4sp33d!'
- Confirm Password: 'then33d4sp33d!'
- Public inbound ports: Open RDP, 3389
- Set the virtual network to **VNET03** 
- Under **Diagnostic storage account** use the previously created Diagnostics storage account


You now have three virtuals machines each in their own subnet and virtual network. Let's validate that.

1. Click on **Monitor** from the left hand pane.
2. Under **Insights** select **Network**, then under **Monitoring** choose **Topology**.
3. User **Resource Group** select **MyVNets**.  In a moment a conceptual network diagram should be generated showing all three vNets and subnets.  Notice that there is no link between vNet1, vNet2, or vNet3.


## Task 5 - Connect to a VM and test connectivity
Before you begin this section, obtain the private and public IP addresses of VM1, VM2, and VM3.

1.	At the top of the Azure portal, enter **VM1**. When VM1 appears in the search results, select it, and the select the **Connect** button.
2.	After selecting the Connect button, click on **Download RDP file**. 
3.	If prompted, select **Connect**. Enter the user name and password you specified when creating the VM. You may need to select **More choices**, then **Use a different account**, to specify the credentials you entered when you created the VM.
4.	Select **OK**.
5.	Click **Yes** on the Networks blade.
6.	From PowerShell, enter *ping vm2*. Ping fails, why is that? **Each virtual network is isolated from other virtual networks and there is no name resolution established.** 
7. To allow VM1 to ping other VMs in a later step, enter the following command from PowerShell, which allows ICMP inbound through the Windows firewall:
_New-NetFirewallRule –DisplayName “Allow ICMPv4-In” –Protocol ICMPv4_.
8. Repeat these steps (connect to the VM and issue the PowerShell command) for VM2 and VM3.

## Task 6 - Connect virtual networks with virtual network peering using the Azure portal
You can connect virtual networks to each other with virtual network peering. These virtual networks can be in the same region or different regions (also known as Global VNet peering). Once virtual networks are peered, resources in both virtual networks are able to communicate with each other, with the same latency and bandwidth as if the resources were in the same virtual network. 

1. In the Search box at the top of the Azure portal, begin typing **vNet1**. When vNet1 appears in the search results, select it.
2. Select **SETTINGS** then **Peerings**, and then select **+ Add**.
3. Enter, or select, the following information, accept the defaults for the remaining settings, and then select **OK**.
    * Name: **vNet1-vNet2**
    * Virtual network: **vNet2 (MyVNets)**
    * Configure virtual network access settings: **Enabled**
    * Configure forwarded traffic settings: **Disabled**
4. Peering status - If you don't see the status, refresh your browser.  Notice the status is *Initiated*.

In the Search box at the top of the Azure portal, begin typing **vNet2**. When **vNet2** appears in the search results, select it.

Complete steps 2-3 again, with the following changes, and then select **OK**:
* Name: **vNet2-vNet1**
* Virtual network: **vNet1 (MyVNets)**
* Configure virtual network access settings: **Enabled**
* Configure forwarded traffic settings: **Disabled**

Peering status - If you don't see the status, refresh your browser.  Notice the status is *Connected*.  Azure also changed the peering status for the vNet1-vNet2 peering from **Initiated** to **Connected**. Virtual network peering is not fully established until the peering status for both virtual networks is **Connected**.

 ## Task 7 -  Test connectivity
 1. At the top of the Azure portal, enter **VM1**. When VM1 appears in the search results, select it. Select the **Connect** button.
 2. After selecting the Connect button, click on **Download RDP file**.
 3. If prompted, select **Connect**. Enter the user name and password you specified when creating the VM. You may need to select More choices, then Use a different account, to specify the credentials you entered when you created the VM. Select **OK**.
 4. Click **Yes** on the Networks blade.
5. From PowerShell, and then ping VM2 by ip address. Ping succeeds, why is that? 

Let's examine our network topology now that we have peering enabled.
1.  Click on **Monitor** from the left hand pane.
2. Under **Insights** select **Network**, then under **Monitoring** choose **Topology**.
3. User **Resource Group** select **MyVNets**.  In a moment a conceptual network diagram should be generated showing all your vNets and subnets including the new peerings between vNet1 and vNet2.


[Back](index.md)