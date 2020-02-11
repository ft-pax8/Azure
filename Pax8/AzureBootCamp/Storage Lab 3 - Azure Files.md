# Lab 3 - Storage: Azure Files

## Before you Begin

There are no prerequisites for this lab.

## Lab Concepts


After completing this lab, you should understand how to:
1. 



## Exercise 1 - Create a New Azure File Share

1. From the Azure Portal, select **+ Create a Resource**
1. Click **Storage** > **Storage account - blob, file, table, queue**
1. Resource Group - click *New* and name is **fileshare**
1. Storage Account = `safiles<first name><last 4 of cell>` *(i.e. safilesjoe1234)*
1. Location = **West US 2**
1. Account kind = **StorageV2 (general purpose v2)**
1. Replication = **Locally-redundant storage (LRS)**
1. Access Tier = **Hot**
1. Click **Review + create**
1. Click **Create** after the successful validation
1. Wait for the deployment to complete and then click on **go to resource**
1. Click on **File Shares** on the menu under *File Service* 
1. Click **+ File Share**
1. Name = **myfiles**
1. Quota = **2 GiB**
1. Click **Create**


## Exercise 2 - Connect to the File Share
There are multiple ways to connect to a file share - SMB, FTPS, NFS, API.  In this exercise, you will connect to your new fileshare using SMB via a Windows UNC/drive mapping.

1. In the Azure portal, browse to your new storage account, file shares and then click on the new file share **myfiles**
1. Click **Connect** on the upper menu
1. You will be presented with a pre-configured script for your specific storage account.  You will run this script on the laptop you are running the lab from.  Click on the appropriate OS of your laptop and copy the script.
1. For Windows, open a PowerShell window - Linux = Command line, Max = Terminal.  If you don't want to do this on your own machine or your machine blocks port 445, use VMSTOR1 from storage Lab 1 
1. Paste the script into the appropriate window and run it
1. Look at the script you pasted in, specifically look at the password.  It should be a long string of alphanumeric and special characters.  This is your storage account access key.  
1. Within the Azure Portal, click on **Access Keys** underneath the storage accounts `Settings` menu and verify that it matches the password in the script.  This key is what allows us to authenticate to the storage account file share since it does not support AAD or ADDS authentication.
1. Once the Z: maps to the fileshare, browse to the Z: drive and verify that you can successfully access it.
1. Upload a file to the Z:, then go back to the Azure portal and click **Refresh** on `myfiles` to see the file you uploaded 
1. Click **+ Add Directory** and give the new directory a name and click **OK**
1. Switch back to the Z: and verify the new directory appears


## Exercise 2 - Maximize Storage Performance
1. By now, you may have identified that the VM size is limiting the performance of read/write operations on the disk because a DS1_v2 only has 32 MB/sec of throughput.





<br></br>
[Back to Table of Contents](./index.md#5-azure-storage)