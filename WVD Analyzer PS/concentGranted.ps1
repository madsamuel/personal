#### Run as administrator

#### Pre-requisites
    # Install AzureRM modules
    Install-Module AzureRM
    Import-Module AzureRM
    # Install AzureAD
    Install-Module AzureAD
    Import-Module AzureAD
    # Install Microsoft.RDInfra.PowerShell
    Install-Module -Name Microsoft.RDInfra.RDPowerShell

#### Admin
# @param
$admin = "admin@gt090617.onmicrosoft.com"
# @param
$password = ""

$passwd = ConvertTo-SecureString $password -AsPlainText -Force
$pscredential = New-Object System.Management.Automation.PSCredential($admin, $passwd)

#### Login to Azure
Login-AzureRmAccount -Credential $pscredential 
#### Login to Azue AD 
Connect-AzureAd -Credential $pscredential 

######## Checking consent
    $wvdObjectID = "321d3fa7-cf15-4173-9579-8117a28a0844" # This is the WVD app
    $sp = (Get-AzureADServicePrincipal -ObjectId $wvdObjectID).ObjectId
    If ($sp -eq "321d3fa7-cf15-4173-9579-8117a28a0844") {
        Write-Host ("Concent granted") -BackgroundColor Green -ForegroundColor Black
    }
    Else {
        Write-Host ("Concent NOT granted") -BackgroundColor Red -ForegroundColor Black
    }
######## Checking consent

######## Assigning TenantCreator role
    # Assign the values to the variables
    # @param
    $username = "admin@gt090617.onmicrosoft.com"
    ########
    $app_id = "5a0aa725-4958-4b0c-80a9-34562e23f3b7"
    $app_role_name = "TenantCreator"

    # Get the user to assign, and the service principal for the app to assign to
    $user = Get-AzureADUser -ObjectId "$username"
    $sp = Get-AzureADServicePrincipal -Filter "AppId eq '$app_id'"
    $appRole = $sp.AppRoles | Where-Object { $_.DisplayName -eq $app_role_name }

    # Assign the user to the app role
    New-AzureADUserAppRoleAssignment -ObjectId $user.ObjectId -PrincipalId $user.ObjectId -ResourceId $sp.ObjectId -Id $appRole.Id

    Try
    {
        New-AzureADUserAppRoleAssignment -ObjectId $user.ObjectId -PrincipalId $user.ObjectId -ResourceId $sp.ObjectId -Id $appRole.Id
        Write-Host ("TenantCreator granted") -BackgroundColor Green -ForegroundColor Black
    }
    Catch
    {
        Write-Host ("TenantCreator already assigned") -BackgroundColor Green -ForegroundColor Black
    }
######## Assigning TenantCreator role

######## Global Admin Test
# @param 
$username = "admin@GT090617.onmicrosoft.com"
# $username = "jeremy@wvdcontoso.com"
# $username = "drewh@wvdcontoso.com"

Try 
{
    $role = Get-AzureADDirectoryRole | Where-Object {$_.displayName -eq 'Company Administrator'}
    if (Get-AzureADDirectoryRoleMember -ObjectId $role.ObjectId | Get-AzureADUser | Where-Object {$_.UserPrincipalName -eq $username}) 
    {
        Write-Host ("User " + $username + " is Global Admin") -BackgroundColor Green -ForegroundColor Black
    }
    Else 
    {
        Write-Host ("User " + $username + " is NOT Global Admin") -BackgroundColor Red -ForegroundColor Black
    }
}
Catch
{
    Write-Host ("User " + $username + " is NOT Global Admin") -BackgroundColor Red -ForegroundColor Black
}
######## Global Admin Test

######## Test WVD tenant exist 
# does not handle tenant groups
$admin = "admin@gt090617.onmicrosoft.com"
# @param
$password = ""
# @param
$tenant = "MVPBootcamp"

$passwd = ConvertTo-SecureString $password -AsPlainText -Force
$pscredential = New-Object System.Management.Automation.PSCredential($admin, $passwd)

Try
{
    Add-RdsAccount -DeploymentUrl "https://rdbroker.wvd.microsoft.com" -Credential $pscredential    
    if ( (Get-RdsTenant -Name $tenant).TenantName -eq $tenant ) 
    {
        Write-Host ("Tenant " + $tenant + " found") -BackgroundColor Green -ForegroundColor Black
    }
    Else
    {
        Write-Host ("Could NOT find tenant " + $tenant) -BackgroundColor Red -ForegroundColor Black
    }
}
Catch
{
    Write-Host ("Could NOT connect to Windows Virtual Desktop") -BackgroundColor Red -ForegroundColor Black
}
######## Test WVD tenant exist 

######## Test WVD permissions
# does not handle tenant groups
$admin = "admin@gt090617.onmicrosoft.com"
# @param
$password = ""
# @param
$tenant = "MVPBootcamp"

$passwd = ConvertTo-SecureString $password -AsPlainText -Force
$pscredential = New-Object System.Management.Automation.PSCredential($admin, $passwd)

Try
{
    Add-RdsAccount -DeploymentUrl "https://rdbroker.wvd.microsoft.com" -Credential $pscredential > $null
    if ( (Get-RdsTenant -Name $tenant).TenantName -eq $tenant ) 
    {
        Write-Host ("Tenant " + $tenant + " found") -BackgroundColor Green -ForegroundColor Black
        If ((Get-RdsRoleAssignment -TenantName $tenant -SignInName $admin).RoleDefinitionName -eq "RDS Owner" ) 
        {
            Write-Host ("User " + $admin + " has permission on WVD tenant" ) -BackgroundColor Green -ForegroundColor Black
        }
        Else
        {
             Write-Host ("User " + $admin + " does NOT have permission on WVD tenant" ) -BackgroundColor Red -ForegroundColor Black
        }
    }
    Else
    {
        Write-Host ("Could NOT find tenant " + $tenant) -BackgroundColor Red -ForegroundColor Black
    }
}
Catch
{
    Write-Host ("Could NOT connect to Windows Virtual Desktop") -BackgroundColor Red -ForegroundColor Black
}
######## Test WVD permissions