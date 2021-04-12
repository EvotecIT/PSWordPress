function Get-WordPressPost {
    [cmdletBinding()]
    param(
        [System.Collections.IDictionary] $Authorization,
        [int] $Id,
        [switch] $List
    )

    if ($List) {
        $Uri = -join ($Authorization.Url, 'posts')
        Invoke-RestMethod -Method get -Uri $Uri -ContentType "application/json" -Headers $Authorization.Header
    }
    if ($Id) {
        $Uri = -join ($Authorization.Url, 'posts/', $Id)
        Invoke-RestMethod -Method get -Uri $Uri -ContentType "application/json" -Headers $Authorization.Header
    }
}