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
2.	*Select **Windows Server 2016 Datacenter*** under *Get Started.  **Note:** You may need to search for the gallery image if you do not see it listed under the popular section.*
3.	Enter or select the following information, accept the defaults for the remaining settings:

    Under **Basics**:
    - Resource Group: select **RG-LAB-NETWORKING**
    - Name: **VMWIN01**
    - Region: *Choose a consistent and supported Region*
    - Size: *Change to **B2ms***
    - Username: `Goose`
    - Password: `then33d4sp33d!`
    - Confirm Password: `then33d4sp33d!`
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
- *Note: VMWIN02 is used in lab 2B and will therefore have a different size, a *Standard* public IP and belong to an Availability set when we create it*
- Availability set: *click **Create New***
      - Name: **AS-IISVMS**
      - *Click **OK***
- Size: Change to **DS2_v2** 
- Username: `Goose`
- Password: `then33d4sp33d!`
- Confirm Password: `then33d4sp33d!`
- Public inbound ports: Open RDP, 3389
- Set the virtual network to **VNET02** 
- Public IP: *Select **Create New*** and *select **Standard*** for the SKU
- Under **Diagnostic storage account** use the previously created Diagnostics storage account


## Task 4 - Create the third VM
Complete the previous steps but use the following information:
- Resource Group: **RG-LAB-NETWORKING**
- Name: **VMWIN03**
- Region: *Choose a consistent supported Region*
- Size: Change to **B2ms**
- Username: `Goose`
- Password: `then33d4sp33d!`
- Confirm Password: `then33d4sp33d!`
- Public inbound ports: Open RDP, 3389
- Set the virtual network to **VNET03** 
- Under **Diagnostic storage account** use the previously created Diagnostics storage account


You now have three virtuals machines each in their own subnet and virtual network. Let's validate that.

1. Click on **Monitor** *(for Azure Monitor)* from the left menu pane.
2. Under **Insights** *select **Network***, then under **Monitoring** *select **Topology***.
3. Under **Resource Group** *select **RG-LAB-NETWORKING***.  In a moment a conceptual network diagram should be generated showing all three vNets and subnets.  Notice that there is no link between VNET01, VNET01, and VNET03.


## Task 5 - Connect to a VM and test connectivity
Before you begin this section, obtain the private and public IP addresses of VMWIN01, VMWIN02, and VMWIN03.

1.	In the search bar at the top of the Azure portal, enter **VMWIN01**. When the appears in the search results, *select it*, and the *select the **Connect** button*
2.	After selecting the Connect button, *click on **Download RDP file*** and open it
3.	If prompted, *select **Connect***. Enter the user name and password you specified when creating the VM. You may need to select **More choices**, then **Use a different account**, to specify the credentials you entered when you created the VM. ***Note:** if the machine you are using for this lab is joined to a domain, you may need to add `.\` before the username to indicate a local account. (eg .\goose)*
4.	*Select **OK***
5.	*Click **Yes*** on the Networks blade that pops-up after logon.
6.	From PowerShell, enter ping VMWIN02's private IP address *(eg `ping 10.2.2.4`)*. Ping fails, why is that? **Each virtual network is isolated from other virtual networks and there is no name resolution established.** 
7. We now want to enable connectivity between our VMs.  To allow VMWIN01 to ping other VMs in a later step, enter the following command from PowerShell, which allows ICMP inbound through the Windows firewall:
`New-NetFirewallRule –DisplayName “Allow ICMPv4-In” –Protocol ICMPv4`
8. Repeat these steps (connect to the VM and issue the PowerShell command) for VMWIN02 and VMWIN03.

## Task 6 - Connect virtual networks with virtual network peering using the Azure portal
You can connect virtual networks to each other with virtual network peering. These virtual networks can be in the same region or different regions (also known as Global VNet peering). Once virtual networks are peered, resources in both virtual networks are able to communicate with each other, with the same latency and bandwidth as if the resources were in the same virtual network. 

1. In the Search box at the top of the Azure portal, begin typing **VNET01**. When VNET01 appears in the search results, select it.
2. Under **SETTINGS** *select **Peerings***, and then *select **+ Add***
3. Enter, or select, the following information, accept the defaults for the remaining settings, and then *select **OK***
    - Peer 1 Name: **PEER-VNET01-VNET02**
    - Virtual network: **VNET02 (RG-LAB-NETWORKING)**
    - Peer 2 Name: **PEER-VNET02-VNET01**
    - Configure virtual network access settings: **Enabled** for both
    - Configure forwarded traffic settings: **Disabled** for both
4. Peering status - If you don't see the status, refresh your browser.  Notice the status is *Initiated*.

In the Search box at the top of the Azure portal, begin typing **VNET02**. When **VNET02** appears in the search results, select it.

Complete steps 2-3 again, with the following changes, and then select **OK**:
- Peer 1 Name: **PEER-VNET02-VNET03**
- Virtual network: **VNET03 (RG-LAB-NETWORKING)**
- Peer 2 Name: **PEER-VNET03-VNET02**
- Configure virtual network access settings: **Enabled** for both
- Configure forwarded traffic settings: **Disabled** for both

Peering status - If you don't see the status, refresh your browser.  Notice the status is *Connected*.  Azure also changed the peering status for the VNET01-VNET02 peering from **Initiated** to **Connected**. Virtual network peering is not fully established until the peering status for both virtual networks is **Connected**.

## Task 7 -  Test connectivity
1. If not still connected to VMWIN01, RDP back into the machine using the steps from Task 5.
2. From PowerShell, ping VMWIN02 by private ip address *(eg `ping 10.2.2.4`)*. Ping succeeds, why is that? 

Let's examine our network topology now that we have peering enabled.
1. Click on **Monitor** *(for Azure Monitor)* from the left menu pane.
2. Under **Insights** *select **Network***, then under **Monitoring** *select **Topology***.
3. Under **Resource Group** *select **RG-LAB-NETWORKING***.  In a moment a conceptual network diagram should be generated showing all your vNets and subnets including the new peerings between VNET01 and VNET02.

[Back](index.md)