function Get-WordPressSetting {
    [cmdletBinding()]
    param(
        [Parameter(Mandatory)][System.Collections.IDictionary] $Authorization
    )
    $QueryParameters = [ordered] @{

    }
    Remove-EmptyValue -Hashtable $QueryParameters
    Invoke-WordpressRestApi -PrimaryUri $Authorization.Url -Uri 'wp-json/wp/v2/settings' -QueryParameter $QueryParameters -Headers $Authorization.Header
}