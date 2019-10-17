# Azure Backup


 
## Azure Backup – Files and Folders

In this lab you are going to complete several activities that highlight the capabilities of Azure backup. 

### Build a Virtual Machine


We need a source environments to backup.

1.	Select **+ Create a resource** found on the upper, left corner of the Azure portal.
2.	Select **Windows Server 2016 Datacenter** *You may need to search for **Windows Server** if you don't see it in the recommendations*
3.	Enter, or select, the following information and accept the defaults for the remaining settings:
    * Resource Group: *CreateNew* **RG-LAB-BCDR**
    * Virtual Machine Name: **VMSource**
    * Region: **East US**
    * Size: **Standard Ds2 v3 (DS2_v3)**
    * Username: `goose`
    * Password: `th3n22d4sp33d!`
    * Confirm Password: `th3n33d4sp33d!`
    * Public inbound ports:  Open RDP
    * select **Next: Disks >**
4.	Click **Next: Networking >**.
5.	Click **Next: Management >**.
6.	Click **Create new** for the **Diagnostic storage account** and  enter `sadiagbcdr`. *Click **OK***, *(Scroll to the bottom and notice the choice to enable backup)* and then *click **Next: Advanced >***. 
7.	Review the items and then click **Next: Review + create >**.
8.	Once validation passes click **Create**.

### Connect to your VM

1.	Once deployment is complete, click on **Go to resource.** 
2.	Click on **Connect**.
3. Select **Download RDP File**.
4. 	Click on **Connect**.
5.	Choose **More Choices** on the Windows Security screen and then **Use a Different Account**.
6.	Enter `.\goose` for user name and then `th3n33d4sp33d!` as the password. Click **Yes** when prompted.
7.	Once your desktop renders click **No** on the **Networks blade**.
8.	Disable IE Enhanced Security Configuration by:
    * Wait for **Server Manager** to open
    * Click **Local Server**
    * Click **On** by **IE Enhanced Security Configuration**
    * Set both modes to **Off**
    * Click **OK**
    * Minimize **Server Manager**

### Copy sample data

1.	Open a **Command Prompt or PowerShell window** under **Windows System** and paste the following command in:

    ```
    net use Z: \\wagsazurefiles.file.core.windows.net\ignite2018 /u:AZURE\wagsazurefiles tCfYh37xGNjIc0czqfTW9+kUHIIhlxRUPh9h4YtD/hh7FiFPn1v32RH7uV0a83E6nAa6kkVU6d+nAAeoBItpJg==
    ```

    > You are mapping a drive to an Azure Files Share.

2.	Switch to the root of c: and enter the following:
    * md c:\bootcamp
    * cd bootcamp
3.	Enter the following command:
    * `Robocopy z:\ c:\bootcamp brk23* /z`
4.	Monitor the file copy process while the files are copied over.  After a few files you can move on to the next section of the lab.

### Create a recovery services vault

To back up your files and folders, you need to create a Recovery Services vault in the region where you want to store the data. 

1. Back in the Azure Portal, click **+ Create a resource** found on the upper, left corner of the Azure portal.  
2. Select **Storage**, then **Backup and Site Recovery**
3. The Recovery Services vault blade opens, enter the following:
   - Resource group: **RG-LAB-BCDR** 
   - Name: **VLT-VMBAK**
   - Location: **East US**
4.	At the bottom of the Recovery Services vault blade click **Create**.
5.	When the alert appears, *click **Go to Resource***

    > It can take several minutes for the Recovery Services vault to be created. Monitor the status notifications in the upper right-hand area of the portal. Once your vault is created, it appears in the list of Recovery Services vaults. If after several minutes you don't see your vault, click Refresh.

### Kickoff a Backup

1.	Open the **Recovery Services** vault then click **Backup** under **Getting Started**.
2.	From the Where is your workload running? drop-down menu, select **Azure**.
3.	From the What do you want to backup? menu, select **Virtual Machine**.
4.	Click **Backup**.
5.	Click **Ok** on the backup policy tab, and then on the Select virtual machines tab select the VM **VMSource** and click **Ok**.  Click **Enable backup**.
6.	At the Azure portal, select **Virtual Machines** then **VMSource**.
7.	Under **Operations** *click **Backup** and then **Backup Now***  *Note: If you see a banner message 'Creating', you must wait for the vault to complete the setup of the VM backup before you can initiate the backup operation*
8.	Choose a date to retain the backup and the click **OK**. Congratulations!  You are now performing a Cloud First Backup!
9.	At the top right of the Azure portal, click on **Notifications** and then **Triggering backup for VMSource**
10.	Click on the backup for **VMSource** and monitor status. The first backup takes about 20/25 minutes to complete.
11.	You can also observe the status by looking at the vault itself.  From the Azure Portal click on Resources Groups then **RG-LAB-BCDR** then **VLT-VMBAK**
12.	Under **Monitoring**, *select **Backup jobs*** to monitor status of you job.

### Delete Data

> Complete this lab once you backup has finished.

1.	Within your RDP session to **VMSource** open **File Explorer**.
2.	Expand This PC, then Windows C:, then bootcamp.
3.	Delete all the files within the bootcamp directory.

### Restore Data

1.	Within the backup vm surf to https://portal.azure.com and logon. 
2.	Select Virtual Machines -> **SourceVM** -> **Backup** under **Operations**.
3.	Click on **File Recovery**.   Select the `Latest` under **Select recovery point** and then **Download Executable**.
4.	Click **Run** when prompted.  Paste the password to run the script from the portal into PowerShell.

    > If you see that 0 recovery volumes have mounted, there was a problem with the process.  Open up Computer Management from Start/Windows Administrative tools.  Click on Disk Management.  Select the 126 GB partition on Disk 2 and assign a drive letter. Copy the files from the mount volume (typically the F: Drive) to c:\ignite.*

5.	Notice the actions taken to mount the volume. Copy the files back to **VMSource** and then type Q to exit.
6.	After identifying the files and copying them to a local storage location, remove (or unmount) the additional drives. To unmount the drives, on the File Recovery menu in the Azure portal, click Unmount Disks.

[Back](index.md)