function Set-WordPressPage {
    [cmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory)][System.Collections.IDictionary] $Authorization,
        [Parameter(Mandatory)][int] $Id,
        [string] $Date,
        [string] $Slug,
        [ValidateSet('publish', 'future', 'draft', 'pending', 'private')][string] $Status,
        [string] $Title,
        [int] $Parent,
        [string] $Password,
        [string] $Content,
        [int] $Author,
        [string] $Excerpt,
        [int] $FeaturedMedia,
        [ValidateSet('open', 'closed')][string] $CommentStatus,
        [ValidateSet('open', 'closed')][string] $PingStatus,
        [string] $Meta,
        [string] $Template,
        [int] $MenuOrder
    )
    $QueryParameters = [ordered] @{
        title          = $Title
        date           = $Date
        slug           = $Slug
        status         = $Status
        password       = $Password
        #content        = $Content
        excerpt        = $Excerpt
        comment_status = $CommentStatus
        ping_status    = $PingStatus
        meta           = $Meta
        template       = $Template
    }
    $BodyParameters = [ordered] @{
        content = $Content
    }
    Remove-EmptyValue -Hashtable $BodyParameters
    if ($Parent) {
        $QueryParameters['parent'] = $Parent
    }
    if ($FeaturedMedia) {
        $QueryParameters['featured_media'] = $FeaturedMedia
    }
    if ($Author) {
        $QueryParameters['author'] = $Author
    }
    if ($MenuOrder) {
        $QueryParameters['menu_order'] = $MenuOrder
    }
    Remove-EmptyValue -Hashtable $QueryParameters
    if ($QueryParameters.Keys.Count -gt 0 -or $BodyParameters.Keys.Count -gt 0) {
        $invokeWordpressRestApiSplat = @{
            PrimaryUri     = $Authorization.Url
            Uri            = "wp-json/wp/v2/pages/$Id"
            QueryParameter = $QueryParameters
            Headers        = $Authorization.Header
            Method         = 'POST'
            Body           = $BodyParameters
        }

        Invoke-WordpressRestApi @invokeWordpressRestApiSplat
    } else {
        Write-Warning "Set-WordPressPage - parameters not provided. Skipping."
    }
}