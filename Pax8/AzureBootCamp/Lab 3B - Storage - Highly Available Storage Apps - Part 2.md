# Highly Available Storage Applications - Part 2

This is part two of Lab 3 for Highly Available Storage Applications. In it, you learn about the benefits of a read-access geo-redundant (RA-GRS) by simulating a failure.
In order to simulate a failure, you will implement Static Routing to simulate failure for requests to the primary endpoint of your read-access geo-redundant (RA-GRS) storage account, causing the application read from the secondary endpoint instead.


<br><br />

## Task 1 - Simulate a Failure with an Invalid Static Route

You can create an invalid static route for all requests to the primary endpoint of your read-access geo-redundant (RA-GRS) storage account. In this tutorial, the local host is used as the gateway for routing requests to the storage account. Using the local host as the gateway causes all requests to your storage account primary endpoint to loop back inside the host, which subsequently leads to failure. Follow the following steps to simulate a failure with an invalid static route.

1. Open the console application in Visual Studio and run it again by *pressing **F5*** or *clicking **start*** to start the debugging.
2. Once the console application begins the dowloand *(when you see the P1, P2, P3, P4....)*, pause the console application by pressing any key while the console window is active
3. Open a Command Prompt as Administrator
4. Retrieve the IP of the storage stamp hosting your storage account **samyapp1** by typing the following at the command prompt:
   
   `nslookup samyapp1.blob.core.windows.net`

5. Write down the IP address of the storage stamp
6. Now retrieve your machine's IP

   `ipconfig`

7. Write down the IP address of your local machine
8. Next, we need to add a static route for your storage account, to route it back to your host to mimic the failure.

   To add a static route for a destination host, type the following command on a Windows command prompt, replacing <destination_ip> with your storage account IP address and <gateway_ip> with your local host IP address.
 
   `route add <destination_ip> <gateway_ip>` 

   If done correctly, you should see the reply > **OK!**


## Task 2 - Verify Storage Failover

The console application has an event handler that is called when the download of the image fails and is set to retry. If the maximum number of retries defined (default is 5)  in the application are reached, the LocationMode of the request is changed to SecondaryOnly. This setting forces the application to attempt to download the image from the secondary endpoint. This configuration reduces the time taken to request the image as the primary endpoint is not retried indefinitely. 
There is a second event handler that is called when the download of the image is successful. If the application is using the secondary endpoint, the application continues to use this endpoint up to 20 times. After 20 times, the application sets the LocationMode back to PrimaryThenSecondary and retries the primary endpoint. If a request is successful, the application continues to read from the primary endpoint.

Let's validate this behavior

1. In the console window running the application, resume the application by pressing any key
2. The application will continue to try to download from primary storage (noted by the **P**) until it fails 5 times, it should then failover to secondary storage (noted by the **S**) and if successful, perform 20 downloads before it retries the primary.  This pattern will continue until the primary is restored, all 999 downloads are complete or both the primary and secondary storage are unreachable.
3. Once you've verified the console application can successfully download from the secondary storage, let's remove the static route so it can reach the primary storage account again.
   - Return to the Command Prompt launched as Administrator
   - Run the following command, replacing <destination_ip> with the IP of the storage stamp
     
     `route delete <destination_ip>`

4. Return to the console application and verify it can now download from primary stoage again.


[Back](index.md)


