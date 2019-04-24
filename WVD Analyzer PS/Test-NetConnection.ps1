Try 
{
    if ((Test-NetConnection -ComputerName "rdbroker.wvd.microsoft.com").RemoteAddress.IPAddressToString -eq '40.113.204.88'  )
    {
        Write-Host ("Windows Virtual Desktop end point is reachable") -BackgroundColor Green -ForegroundColor Black
    }
    Else
    {
        Write-Host ("Windows Virtual Desktop not reachable") -BackgroundColor Red -ForegroundColor Black
    }
}
Catch 
{
    Write-Host ("Windows Virtual Desktop not reachable") -BackgroundColor Red -ForegroundColor Black
}

Test-Connection "rdbroker.wvd.microsoft.com"

##################

Function psp {
   param($InputObject = $null)

   BEGIN {$status = $True}

   PROCESS {
      if ($InputObject -and $_) {
         throw 'ParameterBinderStrings\AmbiguousParameterSet'
      } elseif ($InputObject -or $_) {
         $processObject = $(if ($InputObject) {$InputObject} else {$_})

         write-host "Ping [$processObject]"

         if( (Test-Connection $processObject -Quiet -count 1)) {
            write-host "Ping response OK" -ForegroundColor DarkGreen
         }
         else {
            write-host "Ping failed - host not found" -ForegroundColor red
            $status = $False
         }
      }
      else {throw 'ParameterBinderStrings\InputObjectNotBound'}

    # next processObject
    }

    # Return True if pings to all machines succeed:
    END {return $status}
}

psp "rdbroker.wvd.microsoft.com"

################

Get-WmiObject -List | where {$_.name -Match "Ping"}

Get-WmiObject Win32_PingStatus -filter "rdbroker.wvd.microsoft.com"

################

# First we create the request.
$HTTP_Request = [System.Net.WebRequest]::Create('http://rdbroker.wvd.microsoft.com')

# We then get a response from the site.
$HTTP_Response = $HTTP_Request.GetResponse()

# We then get the HTTP code as an integer.
$HTTP_Status = [int]$HTTP_Response.StatusCode

If ($HTTP_Status -eq 200) {
    Write-Host "Site is OK!"
}
Else {
    Write-Host "The Site may be down, please check!"
}

# Finally, we clean up the http request by closing it.
$HTTP_Response.Close()

########################
$statusCode = wget 'https://rdbroker.wvd.microsoft.com' | % {$_.StatusCode}
#######################
function Get-UrlStatusCode([string] $Url)
{
    try
    {
        (Invoke-WebRequest -Uri $Url -UseBasicParsing -DisableKeepAlive).StatusCode
    }
    catch [Net.WebException]
    {
        [int]$_.Exception.Response.StatusCode
    }
}

$statusCode = Get-UrlStatusCode 'https://rdbroker.wvda.microsoft.com'