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

# So lets read out all Azure where the users have set their PreferredDataLocation
$UsersToMove = Get-MsolUser -All:$true | 
  Select-Object UserPrincipalName,PreferredDataLocation,UsageLocation | 
  Where-Object {
    ($_.PreferredDataLocation -eq 'APC') -or
    ($_.PreferredDataLocation -eq 'AUS') -or
    ($_.PreferredDataLocation -eq 'CAN') -or
    ($_.PreferredDataLocation -eq 'EUR') -or
    ($_.PreferredDataLocation -eq 'FRA') -or
    ($_.PreferredDataLocation -eq 'IND') -or
    ($_.PreferredDataLocation -eq 'JPN') -or
    ($_.PreferredDataLocation -eq 'KOR') -or
    ($_.PreferredDataLocation -eq 'ZAF') -or
    ($_.PreferredDataLocation -eq 'CHE') -or
    ($_.PreferredDataLocation -eq 'ARE') -or
    ($_.PreferredDataLocation -eq 'GBR') -or
    ($_.PreferredDataLocation -eq 'NAM')
    }

# lets loop this, and check for ReadyToTrigger status,
# and start the content to move
foreach($User in $UsersToMove) {
  $MoveState = Get-SPOUserAndContentMoveState -UserPrincipalName $user.UserPrincipalName | Select-Object MoveState
  if($MoveState.MoveState -eq 'ReadyToTrigger') {
    write-host $User.UserPrincipalName $user.PreferredDataLocation 
    Start-SPOUserAndContentMove -UserPrincipalName $User.UserPrincipalName -DestinationDataLocation $user.PreferredDataLocation
    }
  }

# lets get an overview of all MoveAndContent status
Get-SPOUserAndContentMoveState -MoveDirection All | Select-Object UserPrincipalName,SourceDataLocation,DestinationDataLocation,MoveState