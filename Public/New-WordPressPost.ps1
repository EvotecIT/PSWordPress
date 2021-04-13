function New-WordPressPost {
    [cmdletBinding(SupportsShouldProcess)]
    param(
        [System.Collections.IDictionary] $Authorization,
        [string] $Date,
        [string] $Slug,
        [ValidateSet('publish', 'future', 'draft', 'pending', 'private')][string] $Status,
        [string] $Title,
        [string] $Password,
        [string] $Content,
        [int] $Author,
        [string] $Excerpt,
        [int] $FeaturedMedia,
        [ValidateSet('open', 'closed')][string] $CommentStatus,
        [ValidateSet('open', 'closed')][string] $PingStatus,
        [ValidateSet('standard', 'aside', 'chat', 'gallery', 'link', 'image', 'quote', 'status', 'video', 'audio')][string] $Format,
        [string] $Meta,
        [nullable[bool]] $Sticky,
        [int[]] $Tags,
        [int[]] $Categories

    )
    $QueryParameters = [ordered] @{
        title          = $Title
        date           = $Date
        slug           = $Slug
        status         = $Status
        password       = $Password
        content        = $Content
        excerpt        = $Excerpt
        comment_status = $CommentStatus
        ping_status    = $PingStatus
        format         = $Format
        meta           = $Meta
    }

    if ($Tags) {
        $QueryParameters['tags'] = $Tags
    }
    if ($Categories) {
        $QueryParameters['categories'] = $Categories
    }
    if ($FeaturedMedia) {
        $QueryParameters['featured_media'] = $FeaturedMedia
    }
    if ($Author) {
        $QueryParameters['author'] = $Author
    }
    Remove-EmptyValue -Hashtable $QueryParameters
    if ($QueryParameters.Keys.Count -gt 0) {
        Invoke-RestApi -PrimaryUri $Authorization.Url -Uri 'wp-json/wp/v2/posts' -QueryParameter $QueryParameters -Headers $Authorization.Header -Method POST
    } else {
        Write-Warning "New-WordPressPost - parameters not provided. Skipping."
    }
}