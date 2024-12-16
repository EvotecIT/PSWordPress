function Get-WordPressTag {
    [cmdletBinding(DefaultParameterSetName = 'List')]
    param(
        [Parameter(ParameterSetName = 'List', Mandatory)]
        [Parameter(ParameterSetName = 'Id', Mandatory)]
        [System.Collections.IDictionary] $Authorization,

        [Parameter(ParameterSetName = 'Id')][int[]] $Id,
        [Parameter(ParameterSetName = 'List')][int] $Page,
        [Parameter(ParameterSetName = 'List')][int] $RecordsPerPage,
        [Parameter(ParameterSetName = 'List')][string] $Search,
        [Parameter(ParameterSetName = 'List')][string] $Exclude,
        [Parameter(ParameterSetName = 'List')][string] $Include,
        [Parameter(ParameterSetName = 'List')][string] $Slug,
        [Parameter(ParameterSetName = 'List')][string] $Parent,
        [Parameter(ParameterSetName = 'List')][string] $Post,
        [Parameter(ParameterSetName = 'List')][ValidateSet('view', 'embed', 'edit')][string] $Context,
        [Parameter(ParameterSetName = 'List')][ValidateSet('asc', 'desc')][string] $Order,
        [Parameter(ParameterSetName = 'List')][ValidateSet('id', 'include', 'name', 'slug', 'include_slugs', 'term_group', 'description', 'count')][string] $OrderBy,
        [Parameter(ParameterSetName = 'List')][switch] $HideUnused
    )
    if ($Id) {
        foreach ($I in $Id) {
            Invoke-WordpressRestApi -PrimaryUri $Authorization.Url -Uri "wp-json/wp/v2/tags/$I" -Headers $Authorization.Header -QueryParameter @{}
        }
    } else {
        $QueryParameters = [ordered] @{
            context = $Context
            search  = $Search
            include = $Include
            exclude = $Exclude
            order   = $Order
            orderby = $OrderBy
            slug    = $Slug
            tags    = $Tags
            parent  = $Parent
            post    = $Post
        }
        if ($HideUnused) {
            $QueryParameters['hide_empty'] = $HideUnused.IsPresent
        }
        if ($Page) {
            $QueryParameters['page'] = $Page
        }
        if ($RecordsPerPage) {
            $QueryParameters['per_page'] = $RecordsPerPage
        }
        Remove-EmptyValue -Hashtable $QueryParameters
        Invoke-WordpressRestApi -PrimaryUri $Authorization.Url -Uri 'wp-json/wp/v2/tags' -QueryParameter $QueryParameters -Headers $Authorization.Header
    }
}