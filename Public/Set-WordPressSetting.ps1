function Set-WordPressSetting {
    [cmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory)][System.Collections.IDictionary] $Authorization,
        [string] $Title,
        [string] $Description,
        [string] $Url,
        [string] $Email,
        [string] $TimeZone,
        [string] $DateFormat,
        [string] $TimeFormat,
        [string] $StartOfWeek,
        [string] $Language,
        [int] $PostsPerPage,
        [int] $DefaultCategory,
        [int] $DefaultPostFormat,
        [nullable[bool]] $UseSmiles,
        [ValidateSet('open', 'closed')][string] $DefaultPingStatus,
        [ValidateSet('open', 'closed')][string] $DefaultCommentStatus
    )
    $QueryParameters = [ordered] @{
        title                  = $Title
        description            = $Description
        url                    = $Url
        email                  = $Email
        timezone               = $TimeZone
        date_format            = $DateFormat
        time_format            = $TimeFormat
        start_of_week          = $StartOfWeek
        language               = $Language
        default_comment_status = $DefaultPingStatus
        default_ping_status    = $DefaultCommentStatus
    }
    if ($null -ne $UseSmiles) {
        $QueryParameters['use_smiles'] = $UseSmiles
    }
    if ($DefaultCategory) {
        $QueryParameters['posts_per_page'] = $PostsPerPage
    }
    if ($PostsPerPage) {
        $QueryParameters['default_category'] = $DefaultCategory
    }
    if ($DefaultPostFormat) {
        $QueryParameters['default_post_format'] = $DefaultPostFormat
    }
    Remove-EmptyValue -Hashtable $QueryParameters
    if ($QueryParameters.Keys.Count -gt 0) {
        Invoke-RestApi -PrimaryUri $Authorization.Url -Uri 'wp-json/wp/v2/settings' -QueryParameter $QueryParameters -Headers $Authorization.Header -Method POST
    } else {
        Write-Warning "Set-WordPressSetting - parameters not provided. Skipping."
    }
}