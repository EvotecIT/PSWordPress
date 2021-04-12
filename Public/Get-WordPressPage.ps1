function Get-WordPressPage {
    [cmdletBinding()]
    param(
        [System.Collections.IDictionary] $Authorization,
        [int] $Id,
        [switch] $List
    )

    if ($List) {
        $Uri = -join ($Authorization.Url, 'pages')
        Invoke-RestMethod -Method get -Uri $Uri -ContentType "application/json" -Headers $Authorization.Header
    }
    if ($Id) {
        $Uri = -join ($Authorization.Url, 'pages/', $Id)
        Invoke-RestMethod -Method get -Uri $Uri -ContentType "application/json" -Headers $Authorization.Header
    }
}