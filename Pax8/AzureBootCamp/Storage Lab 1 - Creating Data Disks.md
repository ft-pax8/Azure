# Lab 1 - Storage: Creating Data Disks



## Exercise 1 - Create a VM 


1. On the Azure portal menu or from the Home page, select **Create a resource**.
2. *Windows Server 2016 VM* should be in the list of Popular Marketplace elements. If not, try searching for "Windows Server 2016 DataCenter" using the search box on the top.
3. Select the Windows VM and click **Create** to start the VM creation process.
4. Under Resource Group, select new and enter **storagePerf**
5. In the Virtual machine name box, enter **VMSTOR1**
6. In the Location drop-down list, select a consistent region for your resource.
7. For the VM Size, select **DS1 v2**
8. In ADMINISTRATOR ACCOUNT section, enter `goose` for Username and `Complex.Password` for password
9. Leave the defaults for the remaining tabs and fields and click **Review + create.**
10. Click **Create** after successful validation


## Exercise 2 - Add Data Disks
Once your VM is created, you will add additional data disks.  Data disks allow you to create new volumes on the server for permanent application and data storage.  Data disks can be created at the same time as VM creation, or afterward, such as this case.

1. Search for **VMSTOR1** and click on the resource to go to the overview page
2. Under 'Settings', click **Disks**
3. Click **+ Add data disk**
4. Set the LUN to **0**
5. Under Name, select the drop down and click **create disk**
6. Disk Name = **appdata**
7. Resource Group = **storagePerf**
8. Source Type = **None**
9. Click **Change Size**
10. Select **P4** and then **OK**
11. Click **Create**
12. Add a 2nd data disk repeating steps 3-11, with values of LUN=**1**, disk name=**logs** and size=**P10**
13. Add a 3rd data disk repeating steps 3-11, with values of LUN=**2**, disk name=**sqldisk1** and size=**P6**
14. Add a 4th data disk repeating steps 3-11, with values of LUN=**3**, disk name=**sqldisk2** and size=**P6**
15. Leave 'Host Caching' set to **Read-only** for all new disks
16. Click **Save**



<br></br>
[Back to Table of Contents](./index.md#5-storage)