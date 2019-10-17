# Azure VM with MARS Agent
 
## Azure Backup of a VM with the MARS Agent 

In this lab you are going to simulate a backup of an on-premises VM or physical server by using a virtual machine in Azure.  You’ll install the MARS agent, perform a backup, delete some data, and then perform a restore.

## Task 1 - Prepare the "on-premises machince"

For this first part you may use your personal machine or the same machine you used in [Lab 4A - Task 1](Lab%204A%20-%20BCDR%20-%20Azure%20Backup.md#task-1---build-a-virtual-machine).  If you are using your own machine, proceed to Task 2.  If you are using an Azure VM, please use the VM from [Lab 4A - Task 1](Lab%204A%20-%20BCDR%20-%20Azure%20Backup.md#task-1---build-a-virtual-machine), which may already be provisioned if doing the labs in order. 


## Task 2 - Copy sample data
Regardless of which machine  you use *(personal or Azure VM)*, please ensure the sample data is loaded onto the machine.  *The data may already be there if you performed the restore in [Lab 4A - Task 6](Lab%204A%20-%20BCDR%20-%20Azure%20Backup.md#task-6---restore-data) - in which case you can skip this step and move to Task 3.

1.	Open a **Command Prompt** under **Windows System** and paste the following command in:

    ```
    net use Z: \\wagsazurefiles.file.core.windows.net\ignite2018 /u:AZURE\wagsazurefiles tCfYh37xGNjIc0czqfTW9+kUHIIhlxRUPh9h4YtD/hh7FiFPn1v32RH7uV0a83E6nAa6kkVU6d+nAAeoBItpJg==
    ```

    > You are mapping a drive to an Azure Files Share.

2.	Switch to the root of c: and enter the following:

    ```
    md c:\ignite
    ```

3.	Enter the following command:

    ```
    Robocopy z:\ c:\ignite brk2* /z
    ```

4.	Monitor the file copy process while the files are copied over.  After a few files you can move on to the next section of the lab.



## Task 3 - Install the agent

1. From your machine/VM browse to the Azure Portal https://portal.azure.com and then select your Recovery Services Vault called `VLT-VMBAK` . You can find it by clicking on the search box at the top of the portal.
2. In the **Getting Started** section, *click **Backup***
3. From the **Where is your workload running?** drop-down menu, select **On-premises**.
   > You chose On-premises because your Windows Server or Windows computer is a physical or virtual machine that is not in Azure.
4. From the What do you want to backup? menu, select **Files and folders**, and click **Prepare Infrastructure**.
5. Click on the **Download Agent for Windows Server or Windows Client**.
6. Click **Run** to start the MAPS install
7. On the **Installation Settings** menu, accept the defaults and *click **Next***
8. On the **Proxy Configuration** menu, accept the defaults and *click **Next***
9. On the **Microsoft Update Opt-In** menu, *select **Use Microsoft Update when I check for updated (recommended)*** and then *click **Next***
10. *Click **Install*** to start the installation
11. *Click **Proceed to Registration***
12. Switch back to the Azure Portal and check the box for **Already downloaded the agent**, and then *click the **Download button***
13. Save the credentials locally, and then switch back to the agent installation
14. *Click **Browse*** and then surf to the Downloads Directory.  Select the credentials and then *click **Open***
15. *Click **Next*** and then **Generate Passphrase**.  Save the passphrase to the Downloads directory and *click **Finish***
16. Once registration is complete *click **Close***

## Task 4 - Kickoff a Backup

1. Open Microsoft Azure Backup. It should have automatically launched.
2. *Click on **Schedule Backup***, then **Next**.
3. *Click **Add items*** and add the **c:\bootcamp** directory.
4. Accept all defaults for the remaining screens and keep clicking **Next** and then finally **Finish**
5. *Click **Close*** after the scheduled backup job wizard completes the configuration
6. *Click **Backup Now** under *Actions*
7. *Click **Next*** twice and then **Back Up**
6. Observe the status of the backup and click **Close** after it completes
 
## Task 5 - Delete Data

1.	Open **File Explorer**, expand **This PC**, then **Windows C:**, then **bootcamp**
2.	Delete all the files within the **bootcamp** directory.

## Task 6 - Restore Data

1.	Switch back to Microsoft Azure Backup and click **Recover Data**.
2.	Click **Next**, **Next**, Select **c:\** as the volume, then **Mount**.
3.	The recovery volume mounts. Click **Browse** and open the **bootcamp** directory.  Copy the files from the mounted volume to **c:\bootcamp**.  Click **More details** to see network transfer speeds.
4.	Switch back to Microsoft Azure Backup and click **Unmount** to unmount the recovery volume.  Choose **Yes**.

[Back](index.md)