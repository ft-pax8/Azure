# Highly Available Storage Applications(https://docs.microsoft.com/en-us/azure/storage/blobs/storage-create-geo-redundant-storage?tabs=dotnet)

In this lab, you learn how to make your application data highly available in Azure using RA-GRS storage


## Task 1 - Install Visual Studio and Azure Storage Explorer

We will use Visual Studio to run a mock console application that will copy files to Azure storage and check to see if the file was successfully copied to the primary storage account and the geo-replicated secondary storage account.  

1. Download and install the appropriate version of [Visual Studio 2019 - Community](https://visualstudio.microsoft.com/downloads/)

   *Note: If you receive an error stating another package is currently being installed, you will need to reboot your machine and then retry the installation.*


2. Download and install Azure Storage Explorer

<br><br />

## Task 2 - Create a Storage Account

1. Within the Azure Portal, *select **Create a resource*** button found on the upper left-hand corner of the Azure portal
2. *Select **Storage*** from the **New** page
3. *Select **Storage Account***
4. Fill out the storage account form with the following information:
   - Resource Group: **Create New**, Name: **RG-LAB-STORAGE**
   - Storage Account Name: **samyapp1**
   - Location: **EastUS**
   - Performance: **Standard**
   - Account Kind: **StorageV2 (general purpose v2)**
   - Replication: **Read-access geo-redundant storage (RA-GRS)**
   - Access tier (default): **Hot**

5. *Select **Review + create***
6. *Click **Create**

<br><br />

## Task 3 - Download the Application Code

1. Download the sample project from Git Hub [storage-dotnet-circuit-breaker-pattern-ha-apps-using-ra-grs.zip](https://github.com/Azure-Samples/storage-dotnet-circuit-breaker-pattern-ha-apps-using-ra-grs/archive/master.zip)
2. Extract the **storage-dotnet-circuit-breaker-pattern-ha-apps-using-ra-grs.zip** to your local downloands folder

<br><br />

## Task 4 - Open the App Solution and Modify the Connection Strings

In this task you will load the application's solution, install the missing dependencies and add the connection string so the application can connect to the new storage account you created in Task 2.

1. Browse to the unzipped folder and open **CircuitBreaker.sln** in Visual Studio Code
2. Install any missing dependcies and packages if prompted
3. Next we need to configure the connection string by grabbing it from the Azure Portal.  To do that, perform the following steps:
   - In the Azure portal, navigate to your storage account **samyapp1**
   - Select **Access keys** under **Settings**
   - *Copy the **Connection String*** from either the primary or secondary key.
4. Now let's load the connection string and save it as an environment variable so the console application can use it.
   - Open the **Terminal** window built into Visual Studio Code and type in the following command:
     `setx storageconnectionstring <your connection string from the portal>`




