function Get-WordPressSetting {
    [cmdletBinding()]
    param(
        [System.Collections.IDictionary] $Authorization
    )
    $QueryParameters = [ordered] @{

    }
    Remove-EmptyValue -Hashtable $QueryParameters
    Invoke-RestApi -PrimaryUri $Authorization.Url -Uri 'wp-json/wp/v2/settings' -QueryParameter $QueryParameters -Headers $Authorization.Header
}