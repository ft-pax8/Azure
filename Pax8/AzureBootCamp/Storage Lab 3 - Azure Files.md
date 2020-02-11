# Lab 3 - Storage: Azure Files

## Before you Begin

There are no prerequisites for this lab.

## Lab Concepts


After completing this lab, you should understand how to:
1. 


<br></br>

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
1. 


## Exercise 2 - Maximize Storage Performance
1. By now, you may have identified that the VM size is limiting the performance of read/write operations on the disk because a DS1_v2 only has 32 MB/sec of throughput.





<br></br>
[Back to Table of Contents](./index.md#5-azure-storage)