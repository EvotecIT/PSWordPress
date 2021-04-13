function Get-WordPressPage {
    [cmdletBinding(DefaultParameterSetName = 'List')]
    param(
        [Parameter(ParameterSetName = 'List', Mandatory)]
        [Parameter(ParameterSetName = 'Id', Mandatory)]
        [System.Collections.IDictionary] $Authorization,

        [Parameter(ParameterSetName = 'Id')][int] $Id,

        [Parameter(ParameterSetName = 'Id')]
        [Parameter(ParameterSetName = 'List')]
        [ValidateSet('edit', 'view')][string[]] $Context,
        [Parameter(ParameterSetName = 'List')][int] $Include,
        [Parameter(ParameterSetName = 'List')][int] $Exclude,
        [Parameter(ParameterSetName = 'List')][int] $Page,
        [Parameter(ParameterSetName = 'List')][int] $RecordsPerPage,
        [Parameter(ParameterSetName = 'List')][string] $Search,
        [Parameter(ParameterSetName = 'List')][string] $Author,
        [Parameter(ParameterSetName = 'List')][string] $ExcludeAuthor,
        [ValidateSet('publish', 'future', 'draft', 'pending', 'private')][Parameter(ParameterSetName = 'List')][string[]] $Status,
        [Parameter(ParameterSetName = 'List')][string] $Slug,
        [Parameter(ParameterSetName = 'List')][int[]] $Tags,
        [Parameter(ParameterSetName = 'List')][int[]] $ExcludeTags,
        [Parameter(ParameterSetName = 'List')][int[]] $Categories,
        [Parameter(ParameterSetName = 'List')][int[]] $ExcludeCategories,
        [Parameter(ParameterSetName = 'List')][ValidateSet('asc', 'desc')][string] $Order,
        [Parameter(ParameterSetName = 'List')][ValidateSet('author', 'date', 'id', 'include', 'modified', 'parent', 'relevance', 'slug', 'include_slugs', 'title')][string] $OrderBy
    )

    if ($Id) {
        Invoke-RestApi -PrimaryUri $Authorization.Url -Uri "wp-json/wp/v2/pages/$id" -Headers $Authorization.Header -QueryParameter @{}
    } else {
        $QueryParameters = [ordered] @{
            search         = $Search
            author         = $Author
            author_exclude = $ExcludeAuthor
            status         = $Status
            order          = $Order
            orderby        = $OrderBy
            slug           = $Slug
            context        = $Context
        }
        if ($Tags) {
            $QueryParameters['tags'] = $Tags
        }
        if ($Categories) {
            $QueryParameters['categories'] = $Categories
        }
        if ($ExcludeTags) {
            $QueryParameters['tags_exclude'] = $ExludeTags
        }
        if ($ExcludeCategories) {
            $QueryParameters['categories_exclude'] = $ExcludeCategories
        }
        if ($Include) {
            $QueryParameters['include'] = $Include
        }
        if ($Exclude) {
            $QueryParameters['exclude'] = $Exclude
        }
        if ($Page) {
            $QueryParameters['page'] = $Page
        }
        if ($RecordsPerPage) {
            $QueryParameters['per_page'] = $RecordsPerPage
        }
        Remove-EmptyValue -Hashtable $QueryParameters
        Invoke-RestApi -PrimaryUri $Authorization.Url -Uri 'wp-json/wp/v2/pages' -QueryParameter $QueryParameters -Headers $Authorization.Header
    }
}