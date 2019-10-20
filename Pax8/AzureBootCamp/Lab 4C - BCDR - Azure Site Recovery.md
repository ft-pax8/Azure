# Azure Site Recovery  
 
In this lab you will create a VM in Azure to simulate a source VM running in either VMware or Hyper-V on-premises.  We will then replicate (aka migrate) the VM to Azure.

Please note that using this approach represents the fastest way to migrate a VM to Azure.  Typical VM migrations also include the assessment phase, which we are skipping in this lab. 


## Task 1 - Create an IIS VM with PowerShell

In this task you use the Azure CLI to create an Azure Virtual Machine running Windows Server 2016, and install IIS. 

1. Open an Azure CLI window by browsing to [https://shell.azure.com](https://shell.azure.com)

2. Login using your Microsoft Account

3. If prompted, select the default AAD directory

4. If a **Welcome to Azure Cloud Shell** prompt appears after logon, select **PowerShell** as the working CLI.  If it does not appear, you can select **PowerShell** from the drowndown in the upper-left corner once a CLI prompt is presented to you.  Note that you may need to provision a new CLI storage account to save your settings.

5. At the CLI prompt, let's create a new resource group to hold your IIS VM.  Create the resource group by typing in the following command:

   ```CLI
   az group create --name RG-LAB-BCDR-EAST2 --location eastus2
   ```

6. Create the VM by typing in the following command:

   ```CLI
   az vm create \
	--resource-group RG-LAB-BCDR-EAST2 \
	--name VM-IIS-East \
	--location eastus2 \
	--image win2016datacenter \
	--admin-username goose \
	--admin-password th3n33d4sp33d!
   ```

7. Once the VM is created, let's open port 80 so we can access the VM's website from the internet.  Run the follwing command:


   ```CLI
   az vm open-port --port 80 --resource-group RG-LAB-BCDR-EAST2 --name VM-IIS-East
   ```
8. Now let's install IIS using a Custom Script Extension.  Run the following command:

   ```CLI 
   az vm extension set \
	--publisher Microsoft.Compute \
	--version 1.8 \
	--name CustomScriptExtension \
	--vm-name VM-IIS-East \
	--resource-group RG-LAB-BCDR-EAST2 \
	--settings '{"commandToExecute":"powershell.exe Install-WindowsFeature -Name Web-Server"}'
   ```


9. Get the public IP of **VM-IIS-East** by running the following command:

   ```CLI
   az network public-ip show --resource-group RG-LAB-BCDR-EAST2 --name VM-IIS-EastPublicIP
   ```

10. Open a web browser and surf to the public IP address to make sure the webisite is up and running on **VM-IIS-East**

<br></br>

## Task 2 - Create target virtual nework for the recovery VM
We could have ASR automatically create the target network resources (i.e. Virtual networks and subnets) but in a more realistic scenario you'd want to pre-create these resources and place your migrated VMs in those specific networks. 
1. Let's create a new resource group to hold our new VNET within Azure CLI

   ```CLI
   az group create --name RG-LAB-BCDR-WEST --location westus
   ```

2. Now let's create the new VNET within this new resource group

   ```CLI
   az network vnet create --name VNT-BCDR-WEST \
	--resource-group RG-LAB-BCDR-WEST \
	--address-prefix 10.10.0.0/16 \
	--subnet-name VNT-BCDR-SUBNET \
	--subnet-prefix 10.10.10.0/24 \
 	--location westUS
   ```

<br></br>


## Task 3 - Select a replication goal
1. Open the Recovery Service Vault, **VLT-VMBAK** that you created in [Lab 4A - Task 3](Lab%204A%20-%20BCDR%20-%20Azure%20Backup.md#task-3---create-a-recovery-services-vault)
2. In the **Getting Started** Menu, click **Site Recovery** > **Prepare Infrastructure**. 
3. In **Protection goal**, set the following: 
    * Where are your machines located?: **Azure** 
    * Where do you want to replicate your machines to? **To Azure**
    * Click **OK**, and then **OK** again on the **Prepare Infrastructure** tab. 

<br></br>

## Task 4 - Enable replication
1.	In the Azure portal, click **Virtual machines**, and select the **VM-IIS-East**. 
2.	Under **Operations**, click **Disaster recovery**.
3.	In **Configure disaster recovery** > **Target region** select the target region to which you'll replicate and where you create the network resources in Task 2, which should be the West US. Click **Next: Advanced settings**.
4. Under Advanced settings, set the following and click **Next: Review + Start Replication**.
   - VM resource group: **RG-LAB-BCDR-WEST**
   - Virtual network" **VNT-BCDR-WEST**
   - Availability: **Single instance**
   - Under **Replication Settings**, *click **Show details***
     - Ensure the **Recovery services vault** is set to use **VLT-VMBAK**
5. Click on **Review + Start replication**.
6. Review the settings and click **Start replication**. This starts a job to enable replication (aka migration) for the VM.
7. You may notice that vaildating takes a few moments to process.  The fabric is ensuring that resources in your target region can be created and there’s no conflicts.

<br></br>

## Task 5 - Track Replication
1. Once Azure has built the core components replication will begin.  On the alert button (the bell) click on **Enabling replication for 1 vm(s)**.  If you don't see this task yet, Azure may still be provisioning the automation account and service principal.  Wait a couple minutes and check again.
2. Notice the steps as they occur in real time.  The longest step in the process is going to be **Enable replication**.  Select that item and observe the series of steps taking place. IR, or Initial Replication, the time it takes the VM to be copied from source to target.  Notice the Status of IR.  
2. Since it may take 30 minutes to replicate the VM, now may be an appropriate time to take a break or come back to the lab at a later time.
3. You can check percentage complete of replication by **Virtual Machines > VM-IIS-East > Operations > Disaster Recovery**.  You may notice status sits at 0% synchronized for some time and then report upwards of 87% complete on next refresh.

<br></br>

## Task 6 - Run a Test Failover 
In this task, you will perform a test failover of the VM you just added Disaster Recovery to.  A test failover executes a failover but does not make the secondary or migrated VM active.  This drill validates your replication strategy without data loss or downtime and doesn't affect your production environment.
1. Browse to **Virtual Machines > VM-IIS-East > Operations > Disaster Recovery** and then *click **Test Failover***
2.	In Test Failover, select **Latest (lowest RPO)** as the recovery point to use for the failover.  Note the following:
    * **Latest (lowest RPO):** Fails the VM over with the current state of the VM but requires some processing time.
    * **Latest processed (low RTO):** Fails the VM over to the latest recovery point that was processed by the Site Recovery service. The time stamp is shown. With this option, no time is spent processing data, so it provides a low RTO (Recovery Time Objective)
    * **Latest app-consistent:** This option fails over all VMs to the latest app-consistent recovery point (leveraging Windows VSS or Volume Shadow Copy Service). The time stamp is shown.
    * **Custom:** Use this option to fail over to a specific recovery point. This option is useful for performing a test failover.
3.	Select the target Azure virtual network to which Azure VMs in the secondary region will be connected after the failover occurs, which in this lab is **VNT-BCDR-WEST**  
4.	To start the failover, click **OK**. Track progress by selecting the alert in the Notifications window. You can also track the progress by browsing to your recovery services value **VLT-VMBAK** then **Site Recovery Jobs** under *Monitoring*
5.	After the failover finishes (Start the virtual machine task is successful), the replica Azure VM appears in the Azure portal under Virtual Machines. Make sure that the VM is running, sized appropriately, and connected to the appropriate network. ***Note that the VM does not have a Public IP address.***
6.	To delete the VMs that were created during the test failover, select **IIS** from **Virtual Machines**, select **Disaster recovery** under  **Operations**, and then choose **Cleanup test failover**. In Notes, record and save any observations associated with the test failover. Click the box for **Testing is complete** and click **Ok**.
If you don’t delete the failover VM, the VM will continue to run and increase your Azure consumption.

<br></br>

 ## Task 8 - Switch over to the migrated VM
 Once you have validated the migrated VM by performing a test failover, your next step would be to switch over to the migrated VM.  In this lab you will complete the migration.

 1.  Once **Test Failover** is complete, click on **Failover**.
 2. Under **Recovery Point** enure that **(low RTO)** is selected and click **OK**. Note the checkbox to shut down the source VM before failover (migration). 
 Under alerts click the link for **Starting failover** and monitor the failover (migration).
 3. Once failover is complete, click on **Virtual Machines** in the Azure Portal and notice that you have two IIS VMs; one stopped (deallocated) in the East US and then another VM in the Central US that's running.

<br></br>

 ## Task 9 - Make your migrated VM accessible
 When you migrate a VM a public IP address is not added by default and the Virtual Network does not have any Network Security Group rules.  We need to add all of these.

 For real production migrations Microsoft recommends that you add these steps to what is called a recovery plan so that they are automatically built and added as the VM is migrated.

 Please refer to the following articles for detailed steps:
 
 [Set up IP addressing to connect to Azure VMs after failover](https://docs.microsoft.com/en-us/azure/site-recovery/concepts-on-premises-to-azure-networking)
 
 [Add Public IP and NSG to ARM VMs during Test Failover of an ASR Recovery Plan](https://gallery.technet.microsoft.com/scriptcenter/Add-Public-IP-and-NSG-to-a6bb8fee)


[Back](index.md)