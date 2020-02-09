# Lab 2 - Storage: VM and Disk Sizing


## Before you Begin

Please ensure you completed Lab 1 - Storage: Creating Data Disks, as you will use the same VM and disks to complete this lab.

## Lab Concepts

Both Azure VMs and Disks have their own performance metrics, specifically IOPS and throughput.  As such, the VM you provision and have an effect on disk performance and vice-versa.  To ensure your application is as performant as possible, both need to be sized appropriately.  In this lab you will see this dependency in action and how to identify a performance bottle-neck.  You will use IOMeter to generate load on your VM and disks and then analyze the results to see if you're getting the performance you should be getting.  Finally, you will learn how to uncover the bottle-neck and how to correct the issue.

After completing this lab, you should understand how to:
1. 


Use this performance table to help you better understand the analysis questions below:


### Azure Storage Performance

| Storage Type          |  Max IOPS (per disk)  | Max Throughput  |
|-----------------------|-----------------------|-----------------|
| P6 - Premium Storage  |  240                  | 50  MB/sec      |                       
| P20 - Premium Storage |  2,300                | 150 MB/sec      |
| P40 - Premium Storage |  7,500                | 250 MB/sec      | 


### Azure Compute Performance

| Storage Type          |  Max IOPS (per disk)  | Max Throughput  |
|-----------------------|-----------------------|-----------------|
| DS1_v2                |  3200                 | 48  MB/sec      |                       
| DS3_v2                |  12,800               | 192 MB/sec      |





## Exercise 1 - Test Azure Disk Performance


1. RDP into **VMSTOR1**
2. Open Server Maanger and turn off *IE Enhanced Security Configuration*
3. Open a web browser and download the [IOMeter Tool](https://sourceforge.net/projects/iometer/files/iometer-stable/2006-07-27/iometer-2006.07.27.win32.i386-setup.exe/download)
4. Install the tool, accepted all defaults.
5. Launch IOMeter and accept the EULA
6. Click on VMSTOR1 then Worker1
7. Click on the **M: AppData** drive, a red X should appear next to it
8. Change the maximum disk sectors to **500000** (which is 500K or 5 zero's)
9. Click on the **Access Specifications** tab
10. Select `32K; 100% Read; 0% Random` and then click **add**
11. Click the green flag at the top menu to *start tests*
12. Save the results.csv file to the Documents folder
13. IOMeter will warm up the drive by writing to the max sectors, then perform the IO Read using 32KB payloads.
14. Click on the **Results Display** tab and then change the *Update Frequency* to **5** to have it refresh the results every 5 seconds
15. Note the **Total I/Os per Second**, **Total MBs per Second** and **Maximum I/O Response Time (ms)**.  Write the values down (they will fluctuate, but just write down the last seen numbers).
16. Let this run for at least 3-5 mins to ensure you get good sample data
17. After 3-5 mins, click **Stop** on the top menu
18. Select the **Disk Targets** tab and uncheck **M: AppData** and check **L: Logs**
19. Repeat steps 11-17
20. How do the results compare between the test run on the M drive versus the L drive?  Are the pretty close?  Why is this if drive M is a P6 and L is a P40?


<br></br>
[Back to Table of Contents](./index.md#5-azure-storage)