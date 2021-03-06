function Invoke-RestApi {
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
        Write-Warning "Invoke-RestApi - Authorization error. Skipping."
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
    if ($PSCmdlet.ShouldProcess("$($RestSplat.Uri)", "Invoking query with $Method")) {
        try {
            Write-Verbose "Invoke-RestApi - Querying $($RestSplat.Uri) method $Method"
            $OutputQuery = Invoke-RestMethod @RestSplat -Verbose:$false
            if ($Method -in 'GET') {
                if ($OutputQuery) {
                    $OutputQuery
                }

                <#
            if ($OutputQuery.'@odata.nextLink') {
                $RestSplat.Uri = $OutputQuery.'@odata.nextLink'
                $MoreData = Invoke-RestApi @RestSplat -FullUri
                if ($MoreData) {
                    $MoreData
                }
            }
            #>
            } elseif ($Method -in 'POST') {
                $OutputQuery
            } else {
                return $true
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