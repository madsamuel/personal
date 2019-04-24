https://www.koskila.net/how-to-get-the-user-count-for-azure-ad-enterprise-application/#solution

$app_name = "Windows Virtual Desktop"
$sp = Get-AzureADServicePrincipal -Filter "displayName eq '$app_name'"
$assignments = Get-AzureADServiceAppRoleAssignment -ObjectId $sp.ObjectId -All $true
$assignments.Count # this row outputs the number of users of the app

Get-AzureADServiceAppRoleAssignmen


Get-AzureADServicePrincipal -ObjectId $wvdObjectId
Get-AzureADServicePrincipal -ObjectId $wvdObjectId
Get-AzureRmADServicePrincipal -ObjectId $wvdObjectId 
Get-AzureADServiceAppRoleAssignment -ObjectId $wvdObjectId | Select ResourceDisplayName, PrincipalDisplayName,  Id | % {  $_ | Add-Member "AppRoleDisplayName" $appRoles[$_.Id] -Passthru }

Get-AzureADServicePrincipal -ObjectId ea59535b-a261-4c51-95f0-113484137ca6

Get-AzureADServicePrincipal | % {

  # Build a hash table of the service principal's app roles. The 0-Guid is
  # used in an app role assignment to indicate that the principal is assigned
  # to the default app role (or rather, no app role).
  $appRoles = @{ "$([Guid]::Empty.ToString())" = "(default)" }
  $_.AppRoles | % { $appRoles[$_.Id] = $_.DisplayName }

  # Get the app role assignments for this app, and add a field for the app role name
  Get-AzureADServiceAppRoleAssignment -ObjectId ($_.ObjectId) | % {
    $_ | Add-Member "AppRoleDisplayName" $appRoles[$_.Id] -Passthru
  }
} | Export-Csv "c:app_role_assignments.csv" -NoTypeInformation

(Get-AzureADServicePrincipal -ObjectId $wvdObjectId).AppRoles
Get-AzureADServiceAppRoleAssignment -ObjectId $wvdObjectId 

(Get-AzureADServicePrincipal -ObjectId $wvdObjectId) | % {

  # Build a hash table of the service principal's app roles. The 0-Guid is
  # used in an app role assignment to indicate that the principal is assigned
  # to the default app role (or rather, no app role).
  $appRoles = @{ "$([Guid]::Empty.ToString())" = "(default)" }
  $_.AppRoles | % { $appRoles[$_.Id] = $_.DisplayName }

  # Get the app role assignments for this app, and add a field for the app role name
  Get-AzureADServiceAppRoleAssignment -ObjectId ($_.ObjectId) | Select ResourceDisplayName, PrincipalDisplayName,  Id  | % {  $_ | Add-Member "AppRoleDisplayName" $appRoles[$_.Id] -Passthru
  }
} 

Get-AzureADRoleAssignment -ObjectId ea59535b-a261-4c51-95f0-113484137ca6

 $ServicePrincipalId = (Get-AzureADServicePrincipal -Top 1).ObjectId
  Get-AzureADServicePrincipal $ServicePrincipalId

  Get-Process | Where-Object {$_.ProcessName -eq ‘dllhost’}

  $Process = Get-Process
  $Process.ProcessName -eq ‘dllhost’


Test-Connection 
Test-NetConnection -ComputerName "rdbroker.wvd.microsoft.com" -InformationLevel "Detailed"
(Test-NetConnection -ComputerName "rdbroker.wvd.microsoft.com").RemoteAddress.IPAddressToString 
(Find-NetRoute -RemoteIPAddress "13.89.57.7").State