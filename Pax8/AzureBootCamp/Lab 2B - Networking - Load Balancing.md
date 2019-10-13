# Lab 2 - Load Balancer
Load balancing provides a higher level of availability and scale by spreading incoming requests across multiple virtual machines (VMs). You can use the Azure portal to create a load balancer that will load balance virtual machines. In this lab you will learn how to create network resources, back-end servers, and a load balancer at the *Standard* pricing tier.

## Task 1 -  Create a Standard load balancer
In this section you will create a public standard load balancer by using the portal. The public IP address is automatically configured as the load balancer's front end when you create the public IP and the load balancer resource by using the portal. The name of the front end is LB-01.
1.	On the upper-left side of the portal, select **Create a resource** > **Networking** > **Load Balancer**.
2.	In the Create load balancer pane, enter these values:
    - Resource Group: **RG-LAB-NETWORKING**
    - Name: **LB-01**
    - Region: *Choose a consistent and supported location*
    - Type: **Public** 
    - SKU: **Standard**
    - Public IP address name: **LB-01-PUBIP** 
    - Availability zone: **Zone-redundant**
    - *Select **Review + Create***
    - After Validation passes *click **Create***

## Task 2 - Create back-end servers
In this section, we will use VNET02 and add a 2nd virtual machine to the VNET in order to create the back-end pool of your *Standard* load balancer. Then you install Internet Information Services (IIS) on the virtual machines to help test the load balancer.


**Create VMWIN04**
1.	On the upper-left side of the portal, select **Create a resource** > **Compute** > **Windows Server 2016 Datacenter**.
2.	Enter, or select, the following information, accept the defaults for the remaining settings:


    Under **Basics**:
    - Resource Group: select **RG-LAB-NETWORKING**
    - Name: **VMWIN04**
    - Region: *Choose a consistent and supported Region*
    - Availability set: *click **Create New***
      - Name: **AS-IISVMS**
      - *Click **OK***
    - Size: *Change to **DS2_v2***
    - Username: `Goose`
    - Password: `then33d4sp33d!`
    - Confirm Password: `then33d4sp33d!`
    - Public inbound ports: *Select **Allow selected ports***  
      - *Check **RDP, 3389***
    - *Select **Next:Disks***
    - Click **Next: Networking**

3. Under **Networking:**
   - Set the virtual network to **VNET02**
   - *Select **Next: Management***
   - Place this virtual machine in the backend pool of an existing Azure load balancing solution: **Yes**
   - Load balancing options: **Azure load balancer**
   - Select a load balancer: **LB-01**
   - Select a backend pool: *Create new* **BEPool**
   - Select **Create** and then **Next: Management >**

4. Under **Management** 
   - Under **Diagnostic storage account** use the previously created Diagnostics storage account and then click  **Review + create**.
5. Once validation passes *click **Create***



Create LBVM2
1.	By following the previous steps create a second VM:
    * Name: **LBVM2**
    * **LBAVSet** as the existing availability set.
    * **LBVnet** as the virtual network.
    * **myBackendSubnet** as the subnet.
 
### Create NSG rules
In this section, you create NSG rules to allow inbound connections that use HTTP and RDP.
1.	Select **Resource Groups** on the left menu. From the resource list, select **LBRG** then **LBVM1-nsg**.
2.	Under **Settings**, select **Inbound security rules**, and then select **Add**.
3.	Enter the following values for the inbound security rule named **HTTPRule** to allow for inbound HTTP connections that use port 80. Then select **OK**.
    * Source: Service Tag
    * Source service tag: Internet
    * Source port ranges: *
    * Destination: Any
    * Destination port ranges: 80
    * Protocol: TCP
    * Action: Allow 
    * Priority: 100
    * Name: HTTP-In
    * Description: Allow HTTP
 
4.	Repeat the steps except from the resource list, select **LBRG** then **LBVM2-nsg**.

### Install IIS
1.	Select **Virtual Machines** on the left menu, then select **LBVM1**. 
2.	On the Overview page, select **Connect** to RDP into the VM.
3.	Sign in to the VM with your username and password.
4.	Click **Yes** on the Networks blade.
5.	In Server Manager, select **Manage**, and then select **Add Roles and features**. 
6.	In the Add Roles and Features Wizard, use the following values:
    * On the Select installation type page, select Role-based or feature-based installation.
    * On the Select destination server page, select LBVM1.
    * On the Select server role page, select Web Server (IIS) then Add Features.
    * Follow the instructions to complete the rest of the wizard using default settings.
    * Repeat steps 1 to 6 for the virtual machine LBVM2.
7.	Once IIS is installed, on each VM edit the default web page by:
    * In Server Manager, click Tools then IIS Manager
    * Expand the left tree, right-click on Default web site, and then choose Explore
    * Edit the iisstart.html by opening it with notepad.
    * Change the `<title>` line to read: `<title>IIS Windows Server LBVM1</title>`
    * Save the file, repeat the same steps for LBVM2 and change the line to state `<title>IIS Windows Server LBVM2</title>`

### Create resources for the *Standard* load balancer
In this section, you configure load balancer settings for a back-end address pool and a health probe. You also specify load balancer and NAT rules.

#### Create a health probe
To allow the *Standard* load balancer to monitor the status of your app, you use a health probe. The health probe dynamically adds or removes VMs from the load balancer rotation based on their response to health checks. Create a health probe named LBHP to monitor the health of the VMs.
1.	Under **Settings**, select **Health probes**, and then select **Add**.
2.	Use these values, and then select **OK**:
    * **LBHP** for the name of the health probe
    * **HTTP** for the protocol type
    * **80** for the port number
    * **5** for Interval, the number of seconds between probe attempts
    * **2** for Unhealthy threshold, the number of consecutive probe failures that must occur before a VM is considered unhealthy
 
#### Create a load balancer rule
You use a load balancer rule to define how traffic is distributed to the VMs. You define the frontend IP configuration for the incoming traffic and the back-end IP pool to receive the traffic, along with the required source and destination port.

Create a load balancer rule named HTTPRule for listening to port 80 in the front end LoadBalancerFrontEnd. The rule is also for sending load-balanced network traffic to the back-end address pool myBackEndPool, also by using port 80.
1.	Under **Settings**, select **Load balancing rules**, and then select **Add**.
2.	Use these values, and then select **OK**:
    * **HTTPRule** for the name of the load balancer rule
    * **TCP** for the protocol type
    * **80** for the port number
    * **80** for the back-end port
    * **BEPool** for the name of the back-end pool
    * **LBHP**for the name of the health probe 

#### Test the load balancer
1.	Find the public IP address for the load balancer on the Overview screen. Select **All resources**, and then select **LBPublicIP**.
2.	Copy the public IP address, and then paste it into the address bar of your browser. The default page of IIS web server is displayed in the browser, noting LBVM1 or LBVM2 as you refresh your browser.
3.	Shutdown either LBVM1 or LBVM2, whichever VM is responding most frequently.  As the VM is shutting down, refresh your browser.  Once one of the VMs is down, you should only see the live VM rendering you the default website.  You may receive a service unavailable if you refresh during probe attempts. 


[Back](index.md)