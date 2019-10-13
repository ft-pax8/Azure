# Lab 3 - Traffic Manager
This lab requires that you have deploy two instances of a web application running in different Azure regions supported by your subscription (e.g. East US and West US2). The two web application instances serve as primary and backup endpoints for Traffic Manager.

## Task 1 - Create East US Web App
1) On the top left-hand side of the screen, select **Create a resource** > **Web** > **Web App** > **Create**.
2) In Web App, enter or select the following information and enter default settings where none are specified:
   - Resource Group: *Click **Create new*** Name: **RG-LAB-NETWORKING-EAST** 
   - App name: **`<yourinitals>`USWebAppEast** (e.g. abcUSWebAppEast)
   - Runtime stack: **.NET Core 2.2**
   - Region: **East US**
   - Under **App Service Plan** select:
     - Windows Plan: *Click **Create New:*** and Name: **AppPlanUSEast**
     - Sku and Size: *Click **Change size** select **Dev/Test** and then use the **F1** shared tier
     - *Click **Apply***
3) *Select **Review + create** then **Create***.  A default website is created when the Web App is successfully deployed.


## Task 2 - Create West US2 Web App
Repeat the steps in Task 1 using the following values:
- Resource Group: *Click **Create new*** Name: **RG-LAB-NETWORKING-WEST** 
- App name: **`<yourinitals>`USWebAppWest** (e.g. abcUSWebAppWest)
- Runtime stack: **.NET Core 2.2**
- Region: **West US 2**
- Under **App Service Plan** select:
- Windows Plan: *Click **Create New:*** and Name: **AppPlanUSWest**
- Sku and Size: *Click **Change size** select **Dev/Test** and then use the **F1** shared tier
- *Click **Apply***

## Task 3 - Create a Traffic Manager profile
Create a Traffic manager profile that directs user traffic based on endpoint priority.  Azure Traffic Manager helps reduce downtime and improve responsiveness of important applications by routing incoming traffic across multiple deployments in different regions. Built-in health checks and automatic re-routing help ensure high availability if a service fails. Use Traffic Manager with Azure services including Web Apps, Cloud Services and Virtual Machines - or combine it with on-premises services for hybrid deployments and smooth cloud migration.
1) On the top left-hand side of the screen, select **Create a resource** > **Networking** > **Traffic Manager profile**. You may have to type in Traffic Manager Profile.
2) In the Create Traffic Manager profile, enter or select, the following information; accept the defaults for the remaining settings:
   - Name: `<yourinitials>`TM *Note: This name needs to be unique within the trafficmanager.net zone and results in the DNS name, trafficmanager.net which is used to access your Traffic Manager profile.*
   - Routing method: Geographic
   - Resource Group: **RG-LAB-NETWORKING-EAST**
   - *Click **Create***

## Task 4 - Add Traffic Manager endpoints
Add the website in the East US as primary endpoint to route all the user traffic. Add the website in West Europe as a backup endpoint. When the primary endpoint is unavailable, traffic is automatically routed to the secondary endpoint.
1) In the portal’s search bar, search for the Traffic Manager profile name that you created in the preceding section and select the profile in the results that the displayed.  You can also go to the resource from the Alerts window.
2) In Traffic Manager profile, in the **Settings** section, click **Endpoints**, and then click **Add**.
3) Enter, or select, the following information, accept the defaults for the remaining settings, and then select **OK**:
   - Type: **Azure endpoint**
   - Name: **PrimaryEndpoint**
   - Target resource type: **App Service**
   - Target Resource: `<yourinitals>USWebAppEast`
   - Geo-Mapping: **North America / Central America / Caribbean**
   - *Select **OK***
4) Repeat Steps 1-3 Using the following information:
   - Type: **Azure endpoint**
   - Name: **SecondaryEndpoint**
   - Target resource type: **App Service**
   - Target Resource: `<yourinitals>USWebAppWest`
   - Geo-Mapping: **Europe**
   - *Select **OK***

## Task 5 - Test Traffic Manager profile
In this section, you first determine the domain name of your Traffic Manager profile and then view how Traffic Manager fails over to the secondary endpoint when the primary endpoint is unavailable.

Since we have enabled traffic management on a global versus regional perspective, we need to test access to your website from various locations around the world.


#### Determine the DNS name
1.	Click Overview and the Traffic Manager profile displays the DNS name of your newly created Traffic Manager profile.

#### View Traffic Manager in action
1) In a web browser, surf to https://www.whatsmydns.net and enter the DNS name of your Traffic Manager profile, change the record type to CNAME, and click **Search**.
2) Notice which of your endpoints are providing services to the various global locations.  US should be going to East and Europe going to West.
3) In the Azure portal swith to your Traffic Manager profile and notice that all of your endpoints are **Enabled**.
4) Click on **PrimaryEndpoint**, select **Disabled**, the **Save**.
5) In the Azure portal swith to your Traffic Manager profile and notice that **PrimaryEndpoint** is now **Disabled**.
6) Return to https://www.whatsmydns.net and click **Search**, noticing the changes on which endpoint(s) are now responding and which are not.  

***Note:** due to caching, it make take 3-5 minutes for the website to show the region has stop responding.*


[Back](index.md)