# Azure AD - B2B and B2C

Azure B2B (Business to Business) and Azure B2C (Busines to Customer) are how you connect resources with other organizations and customers external to your own organization and tenant.  These features allow you to connect external user identities with your resources, in a secure manner, without taking on the responsibility of managing their identities.  


<br><br />

## Azure AD Business to Business

### Task 1 - Add a Guest Account to your Tenant

In this task, you will add your organizational account or another personal/work Microsoft account as a guest account (B2B) to your newly created AAD tenant that you created in Lab 1A.  


1. Browse to **portal.azure.com**
2. Search for **Azure Active Directory**
3. Click on **Users** under **Manage**
4. Verify you are connected to your newly created tenant `<intials><birthday MMDD format>.onmicrosoft.com`, if you're not, click on your profile at the top right and then click **switch directory** and choose the correct tenant.
5. Click on **New guest user**
6. Fill out the user's name and enter in the email address of a separate Microsoft account that you own (you also need access to this account's email).
7. *Click **Roles*** and then *select **Directory readers*** and then *click **OK***
8. *Click **Invite***


<br><br />

### Task 2 - Accept the AAD B2B Invite

Adding a guest account to your tenant is a mutual agreement.  Therefore, not only must you invite the external identity, but that external identity must also accept your invite.  Once both parties take the appropriate active steps, an external identity can be added to your tenant and you may then add that identity to custom groups or built-in RBAC groups so it may manage or view your resources.  Let's add a guest account.

1. Open the email for the account you added in Task 1 and find the email with the subject **You're invited to the AD Connect Directory organization**
2. Open the email and then *click the **Get Started*** link found within the email
3. Logon with your Microsoft Account and then Click **Accept** to the prompt
4. After you see the shared applications screen, close the browser window
5. If setup correctly, you should now be able to logon to portal.azure.com with your secondary Microsoft account and view the identities within your new tenant.
   - Open a new InPrivate/Incognito browser window
   - Browse to portal.azure.com
   - Logon using your secondary Microsoft account
   - Once logged on, click on your profile in the top right and then *click **switch directory***
   - Choose your lab tenant `<intials><birthday MMDD format>.onmicrosoft.com`.  You may receive a notification that no Azure subscription is associated to this tenant.  This is expected as we only created a tenant, but never created an Azure subscription.
   - Search for **Azure Active Directory** and then browse to **Users** under **Manage**, you should see the users in the tenant, including the on-premises identities that have been synced (OnPrem and ADSync)
   - Notice that you can read the users, but are unable to add a new user due to the lack of RBAC rights

##################################

   > Note that AAD B2B is the basis for many of the ways partners manage customers' accounts in CSP.  Whether it's DAP (Delegated Admin Privledge), Azure Lighthouse, or PAL (Partner Admin Link), all of these are simply using AAD B2B at the foundation.

<br><br />

## Azure AD Business to Customer

You can use AAD B2C to link AAD IDs to consumer identities.  You can then leverage B2C to offer SSO to your business applications that you publish.  In this task, you will tie a consumer identity (Facebook/Twitter/etc.) to an existing AAD user identity and then test SSO functionality.

### Task 3 - Add Facebook/Twitter from the Azure AD gallery
1. From the Azure portal select your Azure Active Directory and then *click **Enterprise Applications*** 
2. Click the **New application** button at the top-right corner on the Enterprise Applications pane.
3. In the Enter a name textbox from the Add from the gallery section, enter Facebook/Twitter.
4. *Click **Add*** to add the application.
5. After a brief period of time, you be able to see the application’s configuration pane.


### Task 4 - Configure single sign-on for Facebook/Twitter from the Azure AD gallery
1. Click the Single sign-on from the application’s left-hand navigation menu.
2. Change the Single Sign-on Mode to Password-based Sign-on and click Save.


Assign users to Facebook
1)	Click on Users and Groups.
2)	Click on Add user.
3)	Click on Users, select On Prem, and then Select.
4)	Click Assign.
Capture the User Access URL
1)	Under Manage click Properties and click the button to copy the URL under User access URL:
 
Test Access
1)	Open an InPrivate browser session and browse to the User access URL.
2)	Logon as On Prem (onprem@yourAzureAD.onmicrosoft.com the password of Complex.Password)
3)	Install the extension, if required.  If using Microsoft Edge you may have to Launch the extension and then turn it on when prompted.
4)	Close and then launch all Edge browsers and once again logon as On Prem to the User access URL.
5)	Enter your personal credentials to Facebook, not On Prem’s since they do not have a Facebook account.
6)	Facebook should open.
7)	Close Microsoft Edge and complete step 1.
8)	Facebook should automatically appear without the need to logon.

