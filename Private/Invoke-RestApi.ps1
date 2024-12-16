function Invoke-WordpressRestApi {
    [cmdletBinding(SupportsShouldProcess)]
    param(
        [alias('PrimaryUri')][uri] $BaseUri,
        [alias('Uri')][uri] $RelativeOrAbsoluteUri,
        [System.Collections.IDictionary] $QueryParameter,
        [alias('Authorization')][System.Collections.IDictionary] $Headers,
        [validateset('GET', 'DELETE', 'POST', 'PATCH')][string] $Method = 'GET',
        [string] $ContentType = "application/json; charset=UTF-8",
        [System.Collections.IDictionary] $Body,
        [switch] $FullUri
    )

    if ($Authorization.Error) {
        Write-Warning "Invoke-WordpressRestApi - Authorization error. Skipping."
        return
    }
    $RestSplat = @{
        Headers     = $Headers
        Method      = $Method
        ContentType = $ContentType
        Body        = $Body | ConvertTo-Json -Depth 5
    }
    Remove-EmptyValue -Hashtable $RestSplat

    if ($FullUri) {
        $RestSplat.Uri = $PrimaryUri
    } else {
        $RestSplat.Uri = Join-UriQuery -QueryParameter $QueryParameter -BaseUri $BaseUri -RelativeOrAbsoluteUri $RelativeOrAbsoluteUri
    }
    $TempProgressPreference = $ProgressPreference
    $ProgressPreference = 'SilentlyContinue'
    if ($PSCmdlet.ShouldProcess("$($RestSplat.Uri)", "Invoking query with $Method")) {
        try {
            Write-Verbose -Message "Invoke-WordpressRestApi - Querying $($RestSplat.Uri) method $Method"
            if ($Method -eq 'GET') {
                if (-not ($QueryParameter.Contains('page'))) {
                    $AllResults = @()
                    $Page = 1
                    do {
                        $CurrentQuery = $QueryParameter + @{ page = $Page }
                        $RestSplat.Uri = Join-UriQuery -QueryParameter $CurrentQuery -BaseUri $BaseUri -RelativeOrAbsoluteUri $RelativeOrAbsoluteUri
                        $Response = Invoke-WebRequest @RestSplat -Verbose:$false
                        $Result = $Response.Content | ConvertFrom-Json
                        $AllResults += $Result
                        if (-not $TotalPages) {
                            $TotalPages = [int]$Response.Headers['X-WP-TotalPages']
                            #Write-Verbose "Invoke-WordpressRestApi - Total pages to retrieve: $TotalPages"
                        }
                        Write-Verbose "Invoke-WordpressRestApi - Querying $($RestSplat.Uri) method $Method [Retrieved page $Page of $TotalPages]"
                        $Page++
                    } while ($Page -le $TotalPages)
                    $ProgressPreference = $TempProgressPreference
                    return $AllResults
                } else {
                    $Response = Invoke-WebRequest @RestSplat -Verbose:$false
                    $ProgressPreference = $TempProgressPreference
                    $Result = $Response.Content | ConvertFrom-Json
                    return $Result
                }
            } else {
                $Response = Invoke-WebRequest @RestSplat -Verbose:$false
                $ProgressPreference = $TempProgressPreference
                $Result = [PSCustomObject]@{
                    Body    = $Response.Content | ConvertFrom-Json
                    Headers = $Response.Headers
                }
                if ($Method -eq 'GET' -or $Method -eq 'POST') {
                    return $Result
                } else {
                    return $true
                }
            }
        } catch {
            $RestError = $_.ErrorDetails.Message
            if ($RestError) {
                try {
                    $ErrorMessage = ConvertFrom-Json -InputObject $RestError
                    $ErrorMy = -join ('JSON Error:' , $ErrorMessage.error.code, ' ', $ErrorMessage.error.message, ' Additional Error: ', $_.Exception.Message)
                    Write-Warning $ErrorMy
                } catch {
                    Write-Warning $_.Exception.Message
                }
            } else {
                Write-Warning $_.Exception.Message
            }
            if ($Method -ne 'GET', 'POST') {
                return $false
            }
        }
    }
}