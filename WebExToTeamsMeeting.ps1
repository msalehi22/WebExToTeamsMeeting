 
<#

    .SYNOPSIS
    Migrate WebEx meeting to Teams using Graph API.

    .DESCRIPTION
    The WebExToTeamsMeeting.ps1 script updates WebEx meetings to Teams meetings

    .INPUT
    WebExToTeamsMeeting.ps1 need a user UPN

    .OUTPUT
    WebExToTeamsMeeting.ps1 generate a number of meetings migrated

    .EXAMPLE
    PS> .\WebExToTeamsMeeting.ps1

    .NOTES
    MIT License

      Copyright (c) 2021 TeamsAdminSamples
  Permission is hereby granted, free of charge, to any person obtaining a copy
  of this software and associated documentation files (the "Software"), to deal
  in the Software without restriction, including without limitation the rights
  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
  copies of the Software, and to permit persons to whom the Software is
  furnished to do so, subject to the following conditions:

  The above copyright notice and this permission notice shall be included in all
  copies or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
  SOFTWARE.


  
#>





#-------------------- Get Access Token ------------------#

# This is the key of the registered AzureAD app
$ClientID = ""
$ClientSecret = ""

# Add your Tenant ID
$TenantId = ""


$RestCalendarQuery = @()



#-------------------- Get Access Token for Calendar event ----------#

$AccessToken = $null
try {​
if($null -eq $AccessToken){​
        $Body = @{​client_id=$ClientID;client_secret=$ClientSecret;grant_type="client_credentials";scope="https://graph.microsoft.com/.default";}​
        $OAuthReq = Invoke-RestMethod -Method Post -Uri https://login.microsoftonline.com/$TenantId/oauth2/v2.0/token -Body $Body
        $AccessToken = $OAuthReq.access_token
    }​
}​
catch {​
    if($null -ne $AccessToken){​
        return $AccessToken
    }​
}​




#-------------------- Create Web Request Header ------------------#

$Headers= @{​'Authorization' = "Bearer $AccessToken"
    'Content-Type'='application/json'
    'Accept'='application/json'
}​




#-------------------- Change Period ------------------#

# AddDays can be changed to any days desired

$StartDate=(get-date)
$StartDate=get-date $StartDate -UFormat %Y-%m-%dT%TZ
$EndDate= (get-date).AddDays(10)
$EndDate = Get-Date $EndDate -UFormat %Y-%m-%dT%TZ



#------------------------Find WebEx Meeting----------------------#

# Replace username@domain.com with the actual user's UPN

$calendarquery = "https://graph.microsoft.com/v1.0/users/username@domain.com/calendar/calendarview?startdatetime=$StartDate&enddatetime=$EndDate"
$RestCalendarQuery = Invoke-RestMethod -Uri $calendarquery -Headers $Headers -Method get -ErrorAction Continue




#------------------------Update WebEx Meeting----------------------#

Foreach($event in $RestCalendarQuery.value) {​
if($event.body.content -match "meet162.webex.com") {​
$subject = $event.subject
Write-Host "Meeting catch $subject"
$eventid = $event.id
# $

# The message can be edited to desired message or leave blank
$content = "WebEx to Teams Meeting Replaced"

# Replace username@domain.com with the actual user's UPN
$calendarevent = "https://graph.microsoft.com/v1.0/users/username@domain.com/calendar/events/$eventid"
$body=@"
    {​
    "body": {​
        "contentType": "HTML",
        "content": "$content"
    }​,
    "isOnlineMeeting": true,
    "onlineMeetingProvider": "teamsForBusiness"
    }​
"@
$restupdateevent = Invoke-RestMethod -Uri $calendarevent -Headers $Headers -Method patch -body $body -ErrorAction Continue
}​
else{​
    Write-Host "No Webex Meeting"
}​
}​
    
#------------------------End of Script----------------------#

  
