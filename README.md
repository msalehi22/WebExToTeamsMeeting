# WebExToTeamsMeeting

The script can be used to migrate WebEx meetings to Teams meeting for a user. This is a proof of concept how to use APIs to programmatically update WebEx meetings to Teams Meetings. Not production-ready code yet.

It still has the most important element: How to connect to exchange and do the actual conversion.

# Pre-Requisites:
## Create Azure AD Application

•	In a tenant where you have Global Admin permissions, sign-in to https://portal.azure.com

•	Navigate to Azure Active Directory > App registrations

•	Click + New registration

•	Provide a Name for your app (example: callRecordsApp)

•	Click Register

•	After app is registered, document the following

    o	Application (client) ID: {guid}
    
    o	Directory (tenant) ID: {guid}
    
•	In the left rail, navigate to Certificates & secrets

•	Click + New client secret

•	After new secret is generated, document the following

    o	Client secret: {string}
    
•	In the left rail, navigate to API permissions

•	Click + Add a permission

    o	Click Microsoft Graph
    o	Click Application permissions
    o	Expand OnlineMeetings (1) and check the box for OnlineMeetings.ReadWrite.All
    o	Expand User (1) and check the box for User.Read.All
    o	Expand Calendars (2) and check the box for Calendars.Read 
    o	Expand Calendars (2) and check the box for Calendars.ReadWrite
    
•	Click Add permissions

•	Remove any other permissions automatically added via App registration process

•	Finally, click Grant admin consent for {tenantName}

•	Output should look like the following

![image](https://user-images.githubusercontent.com/103140887/162042696-936a00a8-2864-4d07-afc7-62ec025f7ec9.png)

