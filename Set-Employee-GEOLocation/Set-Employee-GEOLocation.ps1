<# 
.SYNOPSIS  
  Script for Setting the msDS-preferredDataLocation on your local domain
.DESCRIPTION 
  This script will run over the local domain for each user to set the msDS-preferredDataLocation for that person
  this is needed to move your data from Azure into your region.
  Azure has 3 Global Geographies
    Global Geography 1 - EMEA (Europe, Middle East and Africa), Austria, Finland, France, Ireland, Netherlands
    Global Geography 2 - Asia Pacific, Hong Kong, Japan, Malaysia, Singapore, South Korea
    Global Geography 3 - Americas, Brazil, Chile, United States
  and the data can be stored on the following locations
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

  To prevent damage the script is setup as -WhatIf scenario as can be found in the line of Set-ADUser 
  meaning it will now only display a whatif message on the acocunt.
  its good to have a "dry" run on your AD to check if all countries are setup in your script.
  it not you will see: 
    Region not set: @{Country=; Region=} for accountname@domain.com
  if no country has been setup in the account, the default location will stay in place.

  to perform the changes on the accounts change the following code:
    Set-ADUser -Identity $Aduser.SamAccountName -Replace @{"msDS-preferredDataLocation"=$RegionResult.region} -WhatIf 
  to
    Set-ADUser -Identity $Aduser.SamAccountName -Replace @{"msDS-preferredDataLocation"=$RegionResult.region}

.NOTES 
  Author: Rutger Hermarij
  email:  GitHub@Scatty.nl
  Version 1.0 @ 03-04-2020
.LINK 
  [ISO 3166-1 codes]                                - https://en.wikipedia.org/wiki/ISO_3166-1
  [Azure Regions]                                   - https://azure.microsoft.com/en-us/global-infrastructure/regions/
.EXAMPLE
  ./Set-Employee-GEOLocation.ps1

#>


$ADCountries = @(
  [pscustomobject]@{Region='default';Country='AD'} # Andorra
  [pscustomobject]@{Region='EUR';Country='AE'} # United Arab Emirates (the)
  [pscustomobject]@{Region='default';Country='AF'} # Afghanistan
  [pscustomobject]@{Region='default';Country='AG'} # Antigua and Barbuda
  [pscustomobject]@{Region='default';Country='AI'} # Anguilla
  [pscustomobject]@{Region='default';Country='AL'} # Albania
  [pscustomobject]@{Region='default';Country='AM'} # Armenia
  [pscustomobject]@{Region='default';Country='AO'} # Angola
  [pscustomobject]@{Region='default';Country='AQ'} # Antarctica
  [pscustomobject]@{Region='default';Country='AR'} # Argentina
  [pscustomobject]@{Region='default';Country='AS'} # American Samoa
  [pscustomobject]@{Region='EUR';Country='AT'} # Austria
  [pscustomobject]@{Region='default';Country='AU'} # Australia
  [pscustomobject]@{Region='default';Country='AW'} # Aruba
  [pscustomobject]@{Region='default';Country='AX'} # Åland Islands
  [pscustomobject]@{Region='default';Country='AZ'} # Azerbaijan
  [pscustomobject]@{Region='default';Country='BA'} # Bosnia and Herzegovina
  [pscustomobject]@{Region='default';Country='BB'} # Barbados
  [pscustomobject]@{Region='default';Country='BD'} # Bangladesh
  [pscustomobject]@{Region='EUR';Country='BE'} # Belgium
  [pscustomobject]@{Region='default';Country='BF'} # Burkina Faso
  [pscustomobject]@{Region='default';Country='BG'} # Bulgaria
  [pscustomobject]@{Region='default';Country='BH'} # Bahrain
  [pscustomobject]@{Region='default';Country='BI'} # Burundi
  [pscustomobject]@{Region='default';Country='BJ'} # Benin
  [pscustomobject]@{Region='default';Country='BL'} # Saint Barthélemy
  [pscustomobject]@{Region='default';Country='BM'} # Bermuda  
  [pscustomobject]@{Region='default';Country='BN'} # Brunei Darussalam
  [pscustomobject]@{Region='default';Country='BO'} # Bolivia (Plurinational State of)
  [pscustomobject]@{Region='default';Country='BQ'} # Bonaire
  [pscustomobject]@{Region='default';Country='BR'} # Brazil
  [pscustomobject]@{Region='default';Country='BS'} # Bahamas (the)
  [pscustomobject]@{Region='default';Country='BT'} # Bhutan
  [pscustomobject]@{Region='default';Country='BV'} # Bouvet Island
  [pscustomobject]@{Region='default';Country='BW'} # Botswana
  [pscustomobject]@{Region='default';Country='BY'} # Belarus
  [pscustomobject]@{Region='default';Country='BZ'} # Belize
  [pscustomobject]@{Region='default';Country='CA'} # Canada
  [pscustomobject]@{Region='default';Country='CC'} # Cocos (Keeling) Islands (the)
  [pscustomobject]@{Region='default';Country='CD'} # Congo (the Democratic Republic of the)
  [pscustomobject]@{Region='default';Country='CF'} # Central African Republic (the)
  [pscustomobject]@{Region='default';Country='CG'} # Congo (the)
  [pscustomobject]@{Region='default';Country='CH'} # Switzerland
  [pscustomobject]@{Region='default';Country='CI'} # Côte d'Ivoire
  [pscustomobject]@{Region='default';Country='CK'} # Cook Islands (the)
  [pscustomobject]@{Region='default';Country='CL'} # Chile
  [pscustomobject]@{Region='default';Country='CM'} # Cameroon
  [pscustomobject]@{Region='default';Country='CN'} # China
  [pscustomobject]@{Region='default';Country='CO'} # Colombia
  [pscustomobject]@{Region='default';Country='CR'} # Costa Rica
  [pscustomobject]@{Region='default';Country='CU'} # Cuba
  [pscustomobject]@{Region='default';Country='CV'} # Cabo Verde
  [pscustomobject]@{Region='default';Country='CW'} # Curaçao
  [pscustomobject]@{Region='default';Country='CX'} # Christmas Island
  [pscustomobject]@{Region='default';Country='CY'} # Cyprus
  [pscustomobject]@{Region='EUR';Country='DE'} # Germany
  [pscustomobject]@{Region='default';Country='DJ'} # Djibouti
  [pscustomobject]@{Region='EUR';Country='DK'} # Denmark
  [pscustomobject]@{Region='default';Country='DM'} # Dominica
  [pscustomobject]@{Region='default';Country='DO'} # Dominican Republic (the)
  [pscustomobject]@{Region='default';Country='DZ'} # Algeria
  [pscustomobject]@{Region='default';Country='EC'} # Ecuador
  [pscustomobject]@{Region='default';Country='EE'} # Estonia
  [pscustomobject]@{Region='default';Country='EG'} # Egypt
  [pscustomobject]@{Region='EUR';Country='CZ'} # Czechia
  [pscustomobject]@{Region='default';Country='EH'} # Western Sahara
  [pscustomobject]@{Region='default';Country='ER'} # Eritrea
  [pscustomobject]@{Region='EUR';Country='ES'} # Spain
  [pscustomobject]@{Region='default';Country='ET'} # Ethiopia
  [pscustomobject]@{Region='default';Country='FI'} # Finland
  [pscustomobject]@{Region='default';Country='FJ'} # Fiji
  [pscustomobject]@{Region='default';Country='FK'} # Falkland Islands (the) [Malvinas]
  [pscustomobject]@{Region='default';Country='FM'} # Micronesia (Federated States of)
  [pscustomobject]@{Region='default';Country='FO'} # Faroe Islands (the)
  [pscustomobject]@{Region='FRA';Country='FR'} # France
  [pscustomobject]@{Region='default';Country='GA'} # Gabon
  [pscustomobject]@{Region='GBR';Country='GB'} # United Kingdom of Great Britain and Northern Ireland (the)
  [pscustomobject]@{Region='default';Country='GD'} # Grenada
  [pscustomobject]@{Region='default';Country='GE'} # Georgia
  [pscustomobject]@{Region='default';Country='GF'} # French Guiana
  [pscustomobject]@{Region='default';Country='GG'} # Guernsey
  [pscustomobject]@{Region='default';Country='GH'} # Ghana
  [pscustomobject]@{Region='default';Country='GI'} # Gibraltar
  [pscustomobject]@{Region='default';Country='GL'} # Greenland
  [pscustomobject]@{Region='default';Country='GM'} # Gambia (the)
  [pscustomobject]@{Region='default';Country='GN'} # Guinea
  [pscustomobject]@{Region='default';Country='GP'} # Guadeloupe
  [pscustomobject]@{Region='default';Country='GQ'} # Equatorial Guinea
  [pscustomobject]@{Region='default';Country='GR'} # Greece
  [pscustomobject]@{Region='default';Country='GS'} # South Georgia and the South Sandwich Islands
  [pscustomobject]@{Region='default';Country='GT'} # Guatemala
  [pscustomobject]@{Region='default';Country='GU'} # Guam
  [pscustomobject]@{Region='default';Country='GW'} # Guinea-Bissau
  [pscustomobject]@{Region='default';Country='GY'} # Guyana
  [pscustomobject]@{Region='default';Country='HK'} # Hong Kong
  [pscustomobject]@{Region='default';Country='HM'} # Heard Island and McDonald Islands
  [pscustomobject]@{Region='default';Country='HN'} # Honduras
  [pscustomobject]@{Region='default';Country='HR'} # Croatia
  [pscustomobject]@{Region='default';Country='HT'} # Haiti
  [pscustomobject]@{Region='default';Country='HU'} # Hungary
  [pscustomobject]@{Region='default';Country='ID'} # Indonesia
  [pscustomobject]@{Region='EUR';Country='IE'} # Ireland
  [pscustomobject]@{Region='default';Country='IL'} # Israel
  [pscustomobject]@{Region='default';Country='IM'} # Isle of Man
  [pscustomobject]@{Region='default';Country='IN'} # India
  [pscustomobject]@{Region='default';Country='IO'} # British Indian Ocean Territory (the)
  [pscustomobject]@{Region='default';Country='IQ'} # Iraq
  [pscustomobject]@{Region='default';Country='IR'} # Iran (Islamic Republic of)
  [pscustomobject]@{Region='default';Country='IS'} # Iceland
  [pscustomobject]@{Region='EUR';Country='IT'} # Italy
  [pscustomobject]@{Region='default';Country='JE'} # Jersey
  [pscustomobject]@{Region='default';Country='JM'} # Jamaica
  [pscustomobject]@{Region='default';Country='JO'} # Jordan
  [pscustomobject]@{Region='JPN';Country='JP'} # Japan
  [pscustomobject]@{Region='default';Country='KE'} # Kenya
  [pscustomobject]@{Region='default';Country='KG'} # Kyrgyzstan
  [pscustomobject]@{Region='default';Country='KH'} # Cambodia
  [pscustomobject]@{Region='default';Country='KI'} # Kiribati
  [pscustomobject]@{Region='default';Country='KM'} # Comoros (the)
  [pscustomobject]@{Region='default';Country='KN'} # Saint Kitts and Nevis
  [pscustomobject]@{Region='default';Country='KP'} # Korea (the Democratic People's Republic of)
  [pscustomobject]@{Region='default';Country='KR'} # Korea (the Republic of)
  [pscustomobject]@{Region='default';Country='KW'} # Kuwait
  [pscustomobject]@{Region='default';Country='KY'} # Cayman Islands (the)
  [pscustomobject]@{Region='default';Country='KZ'} # Kazakhstan
  [pscustomobject]@{Region='default';Country='LA'} # Lao People's Democratic Republic (the)
  [pscustomobject]@{Region='default';Country='LB'} # Lebanon
  [pscustomobject]@{Region='default';Country='LC'} # Saint Lucia
  [pscustomobject]@{Region='default';Country='LI'} # Liechtenstein
  [pscustomobject]@{Region='default';Country='LK'} # Sri Lanka
  [pscustomobject]@{Region='default';Country='LR'} # Liberia
  [pscustomobject]@{Region='default';Country='LS'} # Lesotho
  [pscustomobject]@{Region='EUR';Country='LT'} # Lithuania
  [pscustomobject]@{Region='default';Country='LU'} # Luxembourg
  [pscustomobject]@{Region='default';Country='LV'} # Latvia
  [pscustomobject]@{Region='default';Country='LY'} # Libya
  [pscustomobject]@{Region='default';Country='MA'} # Morocco
  [pscustomobject]@{Region='default';Country='MC'} # Monaco
  [pscustomobject]@{Region='default';Country='MD'} # Moldova (the Republic of)
  [pscustomobject]@{Region='default';Country='ME'} # Montenegro
  [pscustomobject]@{Region='default';Country='MF'} # Saint Martin (French part)
  [pscustomobject]@{Region='default';Country='MG'} # Madagascar
  [pscustomobject]@{Region='default';Country='MH'} # Marshall Islands (the)
  [pscustomobject]@{Region='default';Country='MK'} # North Macedonia
  [pscustomobject]@{Region='default';Country='ML'} # Mali
  [pscustomobject]@{Region='default';Country='MM'} # Myanmar
  [pscustomobject]@{Region='default';Country='MN'} # Mongolia
  [pscustomobject]@{Region='default';Country='MO'} # Macao
  [pscustomobject]@{Region='APC';Country='MP'} # Northern Mariana Islands (the)
  [pscustomobject]@{Region='default';Country='MQ'} # Martinique
  [pscustomobject]@{Region='default';Country='MR'} # Mauritania
  [pscustomobject]@{Region='default';Country='MS'} # Montserrat
  [pscustomobject]@{Region='default';Country='MT'} # Malta
  [pscustomobject]@{Region='default';Country='MU'} # Mauritius
  [pscustomobject]@{Region='default';Country='MV'} # Maldives
  [pscustomobject]@{Region='default';Country='MW'} # Malawi
  [pscustomobject]@{Region='default';Country='MX'} # Mexico
  [pscustomobject]@{Region='default';Country='MY'} # Malaysia
  [pscustomobject]@{Region='default';Country='MZ'} # Mozambique
  [pscustomobject]@{Region='default';Country='NA'} # Namibia
  [pscustomobject]@{Region='default';Country='NC'} # New Caledonia
  [pscustomobject]@{Region='default';Country='NE'} # Niger (the)
  [pscustomobject]@{Region='default';Country='NF'} # Norfolk Island
  [pscustomobject]@{Region='default';Country='NG'} # Nigeria
  [pscustomobject]@{Region='default';Country='NI'} # Nicaragua
  [pscustomobject]@{Region='EUR';Country='NL'} # Netherlands (the)
  [pscustomobject]@{Region='EUR';Country='NO'} # Norway
  [pscustomobject]@{Region='default';Country='NP'} # Nepal
  [pscustomobject]@{Region='default';Country='NR'} # Nauru
  [pscustomobject]@{Region='default';Country='NU'} # Niue
  [pscustomobject]@{Region='default';Country='NZ'} # New Zealand
  [pscustomobject]@{Region='default';Country='OM'} # Oman
  [pscustomobject]@{Region='default';Country='PA'} # Panama
  [pscustomobject]@{Region='default';Country='PE'} # Peru
  [pscustomobject]@{Region='default';Country='PF'} # French Polynesia
  [pscustomobject]@{Region='default';Country='PG'} # Papua New Guinea
  [pscustomobject]@{Region='default';Country='PH'} # Philippines (the)
  [pscustomobject]@{Region='default';Country='PK'} # Pakistan
  [pscustomobject]@{Region='EUR';Country='PL'} # Poland
  [pscustomobject]@{Region='default';Country='PM'} # Saint Pierre and Miquelon
  [pscustomobject]@{Region='default';Country='PN'} # Pitcairn
  [pscustomobject]@{Region='default';Country='PR'} # Puerto Rico
  [pscustomobject]@{Region='default';Country='PS'} # Palestine, State of
  [pscustomobject]@{Region='EUR';Country='PT'} # Portugal
  [pscustomobject]@{Region='default';Country='PW'} # Palau
  [pscustomobject]@{Region='default';Country='PY'} # Paraguay
  [pscustomobject]@{Region='default';Country='QA'} # Qatar
  [pscustomobject]@{Region='default';Country='RE'} # Réunion
  [pscustomobject]@{Region='default';Country='RO'} # Romania
  [pscustomobject]@{Region='default';Country='RS'} # Serbia
  [pscustomobject]@{Region='EUR';Country='RU'} # Russian Federation (the)
  [pscustomobject]@{Region='default';Country='RW'} # Rwanda
  [pscustomobject]@{Region='default';Country='SA'} # Saudi Arabia
  [pscustomobject]@{Region='default';Country='SB'} # Solomon Islands
  [pscustomobject]@{Region='default';Country='SC'} # Seychelles
  [pscustomobject]@{Region='default';Country='SD'} # Sudan (the)
  [pscustomobject]@{Region='EUR';Country='SE'} # Sweden
  [pscustomobject]@{Region='default';Country='SG'} # Singapore
  [pscustomobject]@{Region='default';Country='SH'} # Saint Helena
  [pscustomobject]@{Region='default';Country='SI'} # Slovenia
  [pscustomobject]@{Region='default';Country='SJ'} # Svalbard
  [pscustomobject]@{Region='EUR';Country='SK'} # Slovakia
  [pscustomobject]@{Region='default';Country='SL'} # Sierra Leone
  [pscustomobject]@{Region='default';Country='SM'} # San Marino
  [pscustomobject]@{Region='default';Country='SN'} # Senegal
  [pscustomobject]@{Region='default';Country='SO'} # Somalia
  [pscustomobject]@{Region='default';Country='SR'} # Suriname
  [pscustomobject]@{Region='default';Country='SS'} # South Sudan
  [pscustomobject]@{Region='default';Country='ST'} # Sao Tome and Principe
  [pscustomobject]@{Region='default';Country='SV'} # El Salvador
  [pscustomobject]@{Region='default';Country='SX'} # Sint Maarten (Dutch part)
  [pscustomobject]@{Region='default';Country='SY'} # Syrian Arab Republic (the)
  [pscustomobject]@{Region='default';Country='SZ'} # Eswatini
  [pscustomobject]@{Region='default';Country='TC'} # Turks and Caicos Islands (the)
  [pscustomobject]@{Region='default';Country='TD'} # Chad
  [pscustomobject]@{Region='default';Country='TF'} # French Southern Territories (the)
  [pscustomobject]@{Region='default';Country='TG'} # Togo
  [pscustomobject]@{Region='default';Country='TH'} # Thailand
  [pscustomobject]@{Region='default';Country='TJ'} # Tajikistan
  [pscustomobject]@{Region='default';Country='TK'} # Tokelau
  [pscustomobject]@{Region='default';Country='TL'} # Timor-Leste
  [pscustomobject]@{Region='default';Country='TM'} # Turkmenistan
  [pscustomobject]@{Region='default';Country='TN'} # Tunisia
  [pscustomobject]@{Region='default';Country='TO'} # Tonga
  [pscustomobject]@{Region='default';Country='TR'} # Turkey
  [pscustomobject]@{Region='default';Country='TT'} # Trinidad and Tobago
  [pscustomobject]@{Region='default';Country='TV'} # Tuvalu
  [pscustomobject]@{Region='default';Country='TW'} # Taiwan (Province of China)
  [pscustomobject]@{Region='default';Country='TZ'} # Tanzania, the United Republic of
  [pscustomobject]@{Region='default';Country='UA'} # Ukraine
  [pscustomobject]@{Region='default';Country='UG'} # Uganda
  [pscustomobject]@{Region='default';Country='UM'} # United States Minor Outlying Islands (the)
  [pscustomobject]@{Region='default';Country='US'} # United States of America (the)
  [pscustomobject]@{Region='default';Country='UY'} # Uruguay
  [pscustomobject]@{Region='default';Country='UZ'} # Uzbekistan
  [pscustomobject]@{Region='default';Country='VA'} # Holy See (the)
  [pscustomobject]@{Region='default';Country='VC'} # Saint Vincent and the Grenadines
  [pscustomobject]@{Region='default';Country='VE'} # Venezuela (Bolivarian Republic of)
  [pscustomobject]@{Region='default';Country='VG'} # Virgin Islands (British)
  [pscustomobject]@{Region='default';Country='VI'} # Virgin Islands (U.S.)
  [pscustomobject]@{Region='default';Country='VN'} # Viet Nam
  [pscustomobject]@{Region='default';Country='VU'} # Vanuatu
  [pscustomobject]@{Region='default';Country='WF'} # Wallis and Futuna
  [pscustomobject]@{Region='default';Country='WS'} # Samoa
  [pscustomobject]@{Region='default';Country='YE'} # Yemen
  [pscustomobject]@{Region='default';Country='YT'} # Mayotte
  [pscustomobject]@{Region='EUR';Country='ZA'} # South Africa
  [pscustomobject]@{Region='default';Country='ZM'} # Zambia
  [pscustomobject]@{Region='default';Country='ZW'} # Zimbabwe
  )


$ADusers = Get-ADUser -Filter {(Enabled -eq $True) -and (emailaddress -like '*') -and (c -like '*')} -Properties c,SamAccountName,EmailAddress | Select-Object c,SamAccountName,EmailAddress;
# if you would like to process per country replace the NL to the ISO 3166-1 standard of the country
#$ADusers = Get-ADUser -Filter {(Enabled -eq $True) -and (emailaddress -like '*') -and (c -like 'NL')} -Properties c,SamAccountName,EmailAddress | Select-Object c,SamAccountName,EmailAddress;


$i=0;
foreach($Aduser in $Adusers) {
  $i++;
  $percentage = [math]::round($i/($ADusers.Count/100),0)
  Write-Progress -Activity Updating -Status "$percentage% Complete:" -PercentComplete $percentage
  $RegionResult = $ADCountries | Select-Object Country,Region | Where-Object {$_.Country -eq $ADuser.c}
  if($RegionResult.region -ne 'default') {
    Write-Host "Setting Region: " $RegionResult for $Aduser.EmailAddress " "-BackgroundColor DarkGreen -NoNewline 
    Set-ADUser -Identity $Aduser.SamAccountName -Replace @{"msDS-preferredDataLocation"=$RegionResult.region} -WhatIf
    }
  else {
    Write-Host "Region not set: " $RegionResult for $Aduser.EmailAddress " " -BackgroundColor DarkRed
  }
}


