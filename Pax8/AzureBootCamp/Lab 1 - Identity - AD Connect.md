# Hybrid Identity Hands-On Lab

##### [Return to Task 2](#task-2---connect-to-the-domain-controller-and-create-a-user-account)

## Before you Begin
If you are using a Microsoft Azure subscription that was provided to you by Microsoft, you are limited to a specific set of Microsoft Azure regions that you can use. Please use either the **East US, South Central US, West Europe, Southeast Asia, West US 2, or West Central US locations**.
Otherwise you will receive an  error in the portal if you select an unsupported region and attempt to build anything in Microsoft Azure.

**Note:** There are several accounts and domains used in this exercise.  Please pay special attention to the accounts you're creating and for what reason or it can become confusing quickly.  To help faciliate the process, the table below is a high-level reference of the accounts you're creating - although they may not match identically to your own accounts.

| Account Name          |  Account Password                | Domain                     |  Used For                    |
|-----------------------|----------------------------------|----------------------------|------------------------------|
| goose                 | th3n33d4sp33d!                   | <initials><zip code>.com   | Connecting to **adVM**       |
|



 
## Task 1 - Setup an IaaS Domain Controller via JSON Template
We will setup an IaaS VM with Active Directory via a JSON template from GitHub.  Although this domain controller is the in the cloud, we’ll use it to simulate an on-prem domain controller.
Install the domain controller
1.	Logon to your Azure subscription.
2.	Surf to https://azure.microsoft.com/en-us/resources/templates/active-directory-new-domain/ 
3.	Select **Deploy to Azure**. 
4.	Enter the following information:
    - Resource Group: *Select **Create New:** and enter Name:**RG-LAB-IDENTITY***
    - Location: Pick a supported location
    - Admin Username: `goose`
    - Admin Password: `th3n33d4sp33d!`
    - Domain name: `<initials><zip code>.com` ***Note:** the name must be shorted than 15 characters if you choose a custom name*
    - DNS Prefix: `<initials><last 4 digits of cell>`
5.	Scroll down, click **I agree to the terms and conditions stated above** and then **Purchase**.  Monitor the deployment by clicking on the “Deploying Template deployment” tile within the Azure Portal or from within the **Deployments** section under the **Settings** of **RG-LAB-IDENTITY**.
    - Confirm that you don’t have any validation errors.  If you do, correct them before moving forward. 
    - If the deployment fails, examine the logs to see what the root cause is.
    - You’ll need to delete the Resource Group before you try running the template again. 
    - If the template takes you back to the Microsoft Azure portal and the deployment begins, monitor the status for any errors.
6.	The deployment and build of the VM will take upwards of 30 minutes depending on several factors.  Don’t forget that we’re not only spinning up a VM but we are also installing and configuring DNS and running DCPromo.  

**Please return to the instructor’s presentation.**

## Task 2 - Connect to the Domain Controller and create a user account
1.	Connect to the adVM virtual machine and logon with your domain account by selecting **Microsoft Azure / Resource Groups / RG-LAB-IDENTITY / adVM / Connect**.  
2.	Click on **Download RDP File**.
3.	Logon with the fully qualified credentials you wrote down earlier (e.g. `goose@<initials><zip code>.com`).  You may have to choose __More Choices__ then **Use a different account** to enter your new set of credentials.
4.	If prompted, click **No** on the Network Discovery blade.
5.	Within Server Manager, click **Tools** and then **Active Directory Users and Computers**.
6.	Expand the tree and select the **Users Container**
7.	On the toolbar click the icon to create a new user in the current container.  
8.	Create a New User with the following information:
    * First Name: **On**
    * Last Name: **Prem**
    * Full Name: **On Prem**
    * User Logon Name: **onprem**
9.	Click **Next** and set the password to `Complex.Password`. Uncheck **User must change password at next logon**, and set the **Password never expires** checkbox.
10.	Click **Next** then **Finish**.
11.	Minimize the RDP window.
 
## Task 3 - Create a virtual machine
We are creating a small VM to be used later to host the Azure AD Connector service.
1. Return to the Azure portal and click the **Create a Resource** button (the Plus) found on the upper left-hand corner of the Azure portal.
2. Select **Compute** then select **Windows Server 2016 Datacenter**.
3. Fill out the virtual machine Basics form and click Ok:
   - Use existing Resource Group: **RG-LAB-IDENTITY**    
   - Virtual machine name: **ADConnect**
   - Size: Choose anything with at least 2 vCPUs and 7GB RAM such as a **DS2_v2**
   - Username: **ADAdmin**
   - Password: `Complex.Password`
   - Confirm Password: `Complex.Password`
   - Public inbound ports: **Allow selected ports**
   - Select inbound ports: **RDP (3389)** 
4. Click **Next: Disks >**  Review the settings and click **Review + create**.
5.	Click **Create**.  After  validation passes, you monitor deployment status. It should take less than 10 minutes to spin up the VM.
7.	When the VM has been created, the status changes from **Your deployment is complete**.
 
## Task 4 - Join the ADConnect VM to the domain
1. Connect to the **ADConnect VM** and logon as ADAdmin. **Microsoft Azure / Resource Groups / RG-LAB-IDENTITY / ADConnect / Connect**
2. Since the ADConnect VM is not joined to the domain yet, use **.\ADAdmin** as the *user name* to indicate the local account.  The password is the password you setup in Task 3
3. If prompted, click **No** on the Network discovery blade.
4. Depending on which region you chose for setup, the ADConnect VM may or may not have the DNS server set to a value we need.
5. The DNS Server on ADCONNECT may not be set to see the domain controller (adVM), so we need to check that setting.  
6. Open a **Command prompt** and enter *ipconfig /all | more*.
7. If the DNS Server is set to 10.0.0.4, close the Command Prompt window and continue to [Task 5 - Join the Domain.](#task-5---join-the-domain)

#### Configure DNS
8. Within **Server Manager**, click on **Local Server**.
9. Click on **IPv4 address assigned by DHCP, IPv6 enabled setting** for the Ethernet connection.
10. Right-click on the network adapter and choose **Properties**.
11. Select **Internet Protocol Version 4 (TCP/IPv4)** and then click **Properties**.
12. Select the radio button for **Use the following DNS Server addresses:** and Set the DNS server to **10.0.0.4** and click **OK** and then **Close**.
13. You will lose connection to the ADConnect VM, this is expected. Once you are back at the Microsoft Azure Portal, click **Restart** to restart the ADConnect VM.
14. Once the VM is successfully restarted, connect to the ADConnect VM and logon as ADAdmin.



## Task 5 - Join the Domain 
1.	Within **Server Manager**, click on **Local Server**.
2.	Click on **WORKGROUP**, then **Change** to rename this computer or join it to a domain.
3.	Click the radio button for **Domain**, enter your fully-qualified domain name, such as `<initials><zip code>.com`, and click **OK**.
4.	In the Windows Security box enter the AD Domain Admin credentials you specified in the template (Task 1).
5.	Click **Ok** on the Welcome screen, **Ok** on the Computer Name/Domain Changes window, **Close**, then **Restart Now**.

## Task 6 - Install Azure Active Directory
1.	In the Azure Portal, click  **+Create a resource** and then select **Identity**, then **Azure Active Directory**.
2.	Enter the following on the **Create directory tab**:
    * Organization name: **AD Connect Directory** 
    * Initial domain name: `<intials><birthday MMDD format>`
        * Ensure validation passes as your namespace needs to be unique within the *.onmicrosoft.com namespace.  We often see participants choosing a domain name that already exists. If it's not unique, append additional characters/numbers to create a unique name. 
        * _You should write this initial domain  and directory name down._
3.	Click **Create**.  It will take several minutes for the directory to be created. 
4.	Once complete, click **Click here to manage your new directory**.
 
## Task 7 - Create a Sync Account
We are going to create an account that AD Connect will use to perform the synchronization process.
1. In Azure Active Directory, under **Manage** choose **Users** and then under **All users** click on **+New User** and enter the following:
   - User name: **adsync** 
   - Name: **AD Sync Account**
   - Role: *Click on **User** and then select **Global Administrator** and then click **Select***
   - Click on **Show Password** and then copy the password.
2.	Click **Create**.
3.	Open an InPrivate or Incognito browser and surf to https://portal.azure.com.
4.	Login as you’re the AD Sync Account you just created `adsync@<initials><birthday MMDD format>.onmicrosoft.com` and use the temporary password.
 
5.	Change your password to `Complex.Password` and then click **Sign in**
6.	Close your inprivate or incognito browser
 
## Task 8 - Sync Azure AD with Windows Server AD (AD DS)
### Install Azure Active Directory Connect
1.	Connect to the ADConnect VM and logon as your previously created domain account (e.g. `goose@<initials><zip code>.com`).  If you don’t see the VM, you must switch from the directory you just created to the **Default Directory** associated with your subscription.  Click in the upper right-hand corner of the screen to change directories.
2.	When Server Manager opens select Local Server and turn off IE Enhanced Security Configuration for Administrators and Users.
3.	Open Internet Explorer, accept the defaults, and surf to http://go.microsoft.com/fwlink/?LinkId=615771 
4.	Click **Download**, then **Run** when prompted.
5.      Close Internet Explorer once the install completes

## Task 9 -  Configure Azure Active Directory Connect
1.	On the Welcome to Azure AD Connect screen select **I agree** then **Continue**.
2.	Review the screen and select **Use express settings**.
3.	On the **Connect to Azure AD** screen enter your **Azure AD Credentials**.  This would be the *adsync@yourdirectoryname.onmicrosoft.com*  account you created.  Click **Next** and then confirm the credential are validated.
4.	On the **Connect to AD DS screen**, enter the Active Directory Domain Services domain administrator credentials. This would be the account you created in the template. Click **Next** and confirm the credential are validated.  
    * If you get an error about the current security context is not associated with an Active Directory domain or forest, you more than likely didn’t logon with a domain account but rather a local account.  You can verify this by opening a command prompt and entering **whoami**.  Logout and login with a domain account and then restart at step 1 in this section.
5.	On the **Azure AD sign-in configuration** screen, select the checkbox for **Continue without any verified domains** and click **Next**.
    * Since this is a temporary lab environment we are not going use a validated custom domain.
6.	On the **Ready to Configure** screen click **Install**.
7.	It may take 5-10 minutes for Azure AD Connect to complete installation. Read the **Configuration Complete** screen and then click **Exit**.
8. Minimize your RDP window.
 
## Task 10 - Validate Synchronization 
1.	Switch to the Azure portal and examine your Azure AD Directory by clicking on the directory and choosing All users.   You may need to switch directories from the Default Directory to your newly created directory.
2. Note that you should see accounts sourced from Active Directory that have synchronized to Azure Active Directory (e.g. On Prem).

### Congratulations!  Your are now synchronizing Active Directory to Azure Active Directory!!
 


[Back](index.md)