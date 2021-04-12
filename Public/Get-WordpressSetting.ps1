function Get-WordPressSetting {
    [cmdletBinding()]
    param(
        [System.Collections.IDictionary] $Authorization
    )
    $Uri = -join ($Authorization.Url, 'settings')
    Invoke-RestMethod -Method get -Uri $Uri -Headers $Authorization.Header
}