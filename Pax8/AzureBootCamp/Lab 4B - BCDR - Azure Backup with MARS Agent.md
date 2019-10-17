# Azure VM with MARS Agent
 
## Azure Backup of a VM with the MARS Agent 

In this lab you are going to simulate a backup of an on-premises VM or physical server by using a virtual machine in Azure.  You’ll install the MARS agent, perform a backup, delete some data, and then perform a restore.

## Task 1 - Prepare the "on-premises machince"

For this first part you may use your personal machine or the same machine you used in [Lab 4A - Task 1]()


## Task 2 - Copy sample data

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



## Install the agent

1.	From your remote desktop Logon to the Azure Portal https://portal.azure.com and then select your Recovery Services Vault called `MyVault` . You can find it by clicking on the search box at the top of the portal.
2.	In the **Getting Started** section, click **Backup**.
3.	From the Where is your workload running? drop-down menu, select **On-premises**.
    > You chose On-premises because your Windows Server or Windows computer is a physical or virtual machine that is not in Azure.
4.	From the What do you want to backup? menu, select **Files and folders**, and click **Prepare Infrastructure**.
5.	Click on the **Download Agent for Windows Server or Windows Client**.
6.	Click **Run**, then click **Next**, **Next**, then Use **Microsoft Update**, **Next**, **Install**.
7.	Click **Proceed to Registration**.
8.	Switch back to the Azure Portal and check the box for **Already downloaded the agent**, and then click the **Download button**.
9.	Save the credentials locally, and then switch back to the agent installation.
10.	Click **Browse** and then surf to the Downloads Directory.  Select the credentials and then click **Open**.
11.	Click **Next** and then **Generate Passphrase**.  Save the passphrase to the Downloads directory and click **Finish**.
12.	Once registration is complete click **Close**.

## Kickoff a Backup

1. Open Microsoft Azure Backup. It should have automatically launched.
2. Click on **Schedule Backup**, then **Next**.
3. Click *Add items* and add the **c:\ignite** directory.
4. Click **Next** four times, **Finish**, and then **Close**.
5. Click **Backup Now** under Actions, **Next**, then **Back Up**.
6. Observe the status of the backup and click **Close**.
 
## Delete Data

1.	Open **File Explorer**, expand **This PC**, then **Windows C:**, then **ignite**.
2.	Delete all the files within the **ignite** directory.

## Restore Data

1.	Switch back to Microsoft Azure Backup and click **Recover Data**.
2.	Click **Next**, **Next**, Select **c:\** as the volume, then **Mount**.
3.	The recovery volume mounts. Click **Browse** and open the **ignite** directory.  Copy the files from the mounted volume to **c:\ignite**.  Click **More details** to see network transfer speeds.
4.	Switch back to Microsoft Azure Backup and click **Unmount** to unmount the recovery volume.  Choose **Yes**.

[Back](index.md)