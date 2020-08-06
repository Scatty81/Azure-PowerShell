<# 
.SYNOPSIS 
  This script will move the SPO data and Contents to the PreferredDataLocation of the user.
  PreferredDataLocation must be set first, but this can be performed by script: Set-Employee-GEOLocation

.DESCRIPTION 
  if the PreferredDataLocation is set by the user and Synced with Azure
  this script will perform a lookup on all AzureAD users to see what PreferredDataLocation is set.
  once that is done it will move the content to the correct location:
    APC - Asia Pacific          
    AUS - Australia             
    CAN - Canada
    EUR - European Union         
    FRA - France                
    IND - India
    JPN - Japan                  
    KOR - Korea
    ZAF - South Africa
    CHE - Switzerland
    ARE - United Arab Emirates
    GBR - United Kingdom        
    NAM - United States         
  this is further explained in the Set-Employee-GEOLocation script
  the script will check for the status ReadyToTrigger, and once that is set it will actually trigger the account.
  if you would run the script agan this status is set to either success or inPorcess
  meaning it will not trigger again.

  side note: an Azur eadmin account is required in order to move the content.
.NOTES 
  Author: Rutger Hermarij
  email:  GitHub@scatty.nl
  Version 1.0 @ 22-07-2020
  Version 1.1 @ 06-08-2020
    Noticed that it actually wasn't needed to check the PreferredDataLocation, 
    since thats already done in the Set-Employee-GEOLocation script.
    so...created a better one :D
.LINK 
  [SYSTEM default ${env:\userprofile} location]     - C:\Windows\System32\config\systemprofile
.EXAMPLE
  ./SPOUserAndContentGEOLocation.ps1

#>

# lets install the modiles that are not installed at first.
if (-not (Get-Module -ListAvailable -Name MSOnline                 -ErrorAction SilentlyContinue)){Install-Module  -Name MSOnline                 -Force}
if (-not (Get-Module -ListAvailable -Name ExchangeOnlineManagement -ErrorAction SilentlyContinue)){Install-Module  -Name ExchangeOnlineManagement -Force}

# use the credential file in order to read Azure
Function Credential-File() {
  [cmdletbinding()]
    Param(
    [string]$File
    )
  if(Test-Path $File) {
    # File found.
    $Credentials = Import-CliXml -Path "$File";
    return $Credentials;
    }
  else {
    # File not found.
    $Credentials = Get-Credential -Message "Credentials Needed"
    $Credentials | Export-CliXml -Path "$File";
    $Credentials = Import-CliXml -Path "$File";
    return $Credentials;
    }
  }

# create a credential file for reading your Azure tenant (global read is enough here)
# for triggering the actual move you need to uncomment Connect-SPOService line
$Credentials = Credential-File -File "${env:\userprofile}\SPOUserAndContentGEOLocation.credentials";
Connect-MsolService -Credential $Credentials;

# lets connect to SPO with an admin account (sorry no credential file here)
# you need to uncomment this field, since you need permissions to start the migration here.
# and change github to the correct tenant ;-)
#Connect-SPOService  -url https://github-admin.sharepoint.com

# so lets check what users actually have the ReadyToTrigger parameter set.
$SPOUsersToMove = Get-SPOUserAndContentMoveState -MoveDirection MoveOut | 
  Select-Object UserPrincipalName,SourceDataLocation,DestinationDataLocation,MoveState,TimeStamp,@{Name='Country';Expression={(Get-MsolUser -UserPrincipalName $_.UserPrincipalName  | Select-Object -ExpandProperty Country)}} | 
  Where-Object {$_.MoveState -match 'ReadyToTrigger'} | 
  Sort-Object 'Country'

# here we can see the output
#$SPOUsersToMove | Out-GridView

# its possible that you have a lot of data. its better to move the data per country.
# in case you just want to move it all at the same time, just remove the if function
foreach($SPOUser in $SPOUsersToMove) {
  if($SPOUser.Country -match 'Poland') { # August 13
    write-host $SPOUser.SourceDataLocation $SPOUser.DestinationDataLocation $SPOUser.MoveState $SPOUser.Country  $SPOUser.UserPrincipalName  -BackgroundColor DarkGreen 
    Start-SPOUserAndContentMove -UserPrincipalName $SPOUser.UserPrincipalName -DestinationDataLocation $SPOUser.DestinationDataLocation -PreferredMoveBeginDate 'August 13, 2020 18:00:00'
    }
  elseif($SPOUser.Country -match 'Portugal') { # August 14
    write-host $SPOUser.SourceDataLocation $SPOUser.DestinationDataLocation $SPOUser.MoveState $SPOUser.Country  $SPOUser.UserPrincipalName  -BackgroundColor DarkGreen
    Start-SPOUserAndContentMove -UserPrincipalName $SPOUser.UserPrincipalName -DestinationDataLocation $SPOUser.DestinationDataLocation -PreferredMoveBeginDate 'August 14, 2020 18:00:00'
    }
  elseif($SPOUser.Country -match 'Russian Federation') { # August 15
    write-host $SPOUser.SourceDataLocation $SPOUser.DestinationDataLocation $SPOUser.MoveState $SPOUser.Country  $SPOUser.UserPrincipalName  -BackgroundColor DarkGreen 
    Start-SPOUserAndContentMove -UserPrincipalName $SPOUser.UserPrincipalName -DestinationDataLocation $SPOUser.DestinationDataLocation -PreferredMoveBeginDate 'August 15, 2020 18:00:00'
    }
  elseif($SPOUser.Country -match 'South Africa') { # August 16
    write-host $SPOUser.SourceDataLocation $SPOUser.DestinationDataLocation $SPOUser.MoveState $SPOUser.Country  $SPOUser.UserPrincipalName  -BackgroundColor DarkGreen 
    Start-SPOUserAndContentMove -UserPrincipalName $SPOUser.UserPrincipalName -DestinationDataLocation $SPOUser.DestinationDataLocation -PreferredMoveBeginDate 'August 16, 2020 18:00:00'
    }
  elseif($SPOUser.Country -match 'Sweden') { # August 17
    write-host $SPOUser.SourceDataLocation $SPOUser.DestinationDataLocation $SPOUser.MoveState $SPOUser.Country  $SPOUser.UserPrincipalName  -BackgroundColor DarkGreen 
    Start-SPOUserAndContentMove -UserPrincipalName $SPOUser.UserPrincipalName -DestinationDataLocation $SPOUser.DestinationDataLocation -PreferredMoveBeginDate 'August 16, 2020 18:00:00'
    }
  elseif($SPOUser.Country -match 'Czech Republic') { # August 18
    write-host $SPOUser.SourceDataLocation $SPOUser.DestinationDataLocation $SPOUser.MoveState $SPOUser.Country  $SPOUser.UserPrincipalName  -BackgroundColor DarkGreen 
    Start-SPOUserAndContentMove -UserPrincipalName $SPOUser.UserPrincipalName -DestinationDataLocation $SPOUser.DestinationDataLocation -PreferredMoveBeginDate 'August 18, 2020 18:00:00'
    }
  elseif($SPOUser.Country -match 'Slovakia') {
    write-host $SPOUser.SourceDataLocation $SPOUser.DestinationDataLocation $SPOUser.MoveState $SPOUser.Country  $SPOUser.UserPrincipalName  -BackgroundColor DarkGreen 
    Start-SPOUserAndContentMove -UserPrincipalName $SPOUser.UserPrincipalName -DestinationDataLocation $SPOUser.DestinationDataLocation -PreferredMoveBeginDate 'August 19, 2020 18:00:00'
    }
  elseif($SPOUser.Country -match 'Northern Mariana Islands') {
    write-host $SPOUser.SourceDataLocation $SPOUser.DestinationDataLocation $SPOUser.MoveState $SPOUser.Country  $SPOUser.UserPrincipalName  -BackgroundColor DarkGreen 
    Start-SPOUserAndContentMove -UserPrincipalName $SPOUser.UserPrincipalName -DestinationDataLocation $SPOUser.DestinationDataLocation -PreferredMoveBeginDate 'August 19, 2020 18:00:00'
    }
  elseif($SPOUser.Country -match 'Lithuania') {
    write-host $SPOUser.SourceDataLocation $SPOUser.DestinationDataLocation $SPOUser.MoveState $SPOUser.Country  $SPOUser.UserPrincipalName  -BackgroundColor DarkGreen 
    Start-SPOUserAndContentMove -UserPrincipalName $SPOUser.UserPrincipalName -DestinationDataLocation $SPOUser.DestinationDataLocation -PreferredMoveBeginDate 'August 19, 2020 18:00:00'
    }
    else {
    write-host $SPOUser.SourceDataLocation $SPOUser.DestinationDataLocation $SPOUser.MoveState $SPOUser.Country  $SPOUser.UserPrincipalName  -BackgroundColor DarkRed
    }
  }

# lets get an overview of all MoveAndContent status
Get-SPOUserAndContentMoveState -MoveDirection All | Select-Object UserPrincipalName,SourceDataLocation,DestinationDataLocation,MoveState