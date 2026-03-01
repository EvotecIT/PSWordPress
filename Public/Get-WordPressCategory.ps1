function Get-WordPressCategory {
    [cmdletBinding(DefaultParameterSetName = 'List')]
    param(
        [Parameter(ParameterSetName = 'List', Mandatory)]
        [Parameter(ParameterSetName = 'Id', Mandatory)]
        [System.Collections.IDictionary] $Authorization,

        [Parameter(ParameterSetName = 'Id')][int[]] $Id,
        [Parameter(ParameterSetName = 'List')][int] $Page,
        [Parameter(ParameterSetName = 'List')][int] $RecordsPerPage,
        [Parameter(ParameterSetName = 'List')][string] $Search,
        [Parameter(ParameterSetName = 'List')][int[]] $Exclude,
        [Parameter(ParameterSetName = 'List')][int[]] $Include,
        [Parameter(ParameterSetName = 'List')][string] $Slug,
        [Parameter(ParameterSetName = 'List')][int] $Parent,
        [Parameter(ParameterSetName = 'List')][int] $Post,
        [Parameter(ParameterSetName = 'List')][ValidateSet('view', 'embed', 'edit')][string] $Context,
        [Parameter(ParameterSetName = 'List')][ValidateSet('asc', 'desc')][string] $Order,
        [Parameter(ParameterSetName = 'List')][ValidateSet('id', 'include', 'name', 'slug', 'include_slugs', 'term_group', 'description', 'count')][string] $OrderBy,
        [Parameter(ParameterSetName = 'List')][switch] $HideUnused,

        [Parameter(ParameterSetName = 'Id')]
        [Parameter(ParameterSetName = 'List')]
        [string] $Language,
        [Parameter(ParameterSetName = 'Id')]
        [Parameter(ParameterSetName = 'List')]
        [string[]] $Fields,
        [Parameter(ParameterSetName = 'Id')]
        [Parameter(ParameterSetName = 'List')]
        [System.Collections.IDictionary] $AdditionalQuery
    )

    $AdditionalParameters = [ordered] @{}
    if ($Language) {
        $AdditionalParameters['wpml_language'] = $Language
    }
    if ($Fields) {
        $AdditionalParameters['_fields'] = $Fields -join ','
    }
    if ($AdditionalQuery) {
        foreach ($Key in $AdditionalQuery.Keys) {
            $AdditionalParameters[$Key] = $AdditionalQuery[$Key]
        }
    }
    Remove-EmptyValue -Hashtable $AdditionalParameters

    if ($Id) {
        foreach ($I in $Id) {
            Invoke-WordpressRestApi -PrimaryUri $Authorization.Url -Uri "wp-json/wp/v2/categories/$I" -Headers $Authorization.Header -QueryParameter $AdditionalParameters
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
        foreach ($Key in $AdditionalParameters.Keys) {
            $QueryParameters[$Key] = $AdditionalParameters[$Key]
        }
        Remove-EmptyValue -Hashtable $QueryParameters
        Invoke-WordpressRestApi -PrimaryUri $Authorization.Url -Uri 'wp-json/wp/v2/categories' -QueryParameter $QueryParameters -Headers $Authorization.Header
    }
}
