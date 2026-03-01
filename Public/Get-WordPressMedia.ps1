function Get-WordPressMedia {
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
        [Parameter(ParameterSetName = 'List')][int[]] $Parent,
        [Parameter(ParameterSetName = 'List')][int[]] $ParentExclude,
        [Parameter(ParameterSetName = 'List')][ValidateSet('view', 'embed', 'edit')][string] $Context,
        [Parameter(ParameterSetName = 'List')][ValidateSet('asc', 'desc')][string] $Order,
        [Parameter(ParameterSetName = 'List')][ValidateSet('author', 'date', 'id', 'include', 'modified', 'parent', 'relevance', 'slug', 'include_slugs', 'title')][string] $OrderBy,
        [Parameter(ParameterSetName = 'List')][ValidateSet('inherit', 'private', 'trash')][string] $Status,
        [Parameter(ParameterSetName = 'List')][ValidateSet('image', 'video', 'text', 'application', 'audio')][string] $MediaType,
        [Parameter(ParameterSetName = 'List')][string] $MimeType,

        [Parameter(ParameterSetName = 'Id')]
        [Parameter(ParameterSetName = 'List')]
        [switch] $Embed,
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
    if ($Embed) {
        $AdditionalParameters['_embed'] = 1
    }
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
            Invoke-WordpressRestApi -PrimaryUri $Authorization.Url -Uri "wp-json/wp/v2/media/$I" -Headers $Authorization.Header -QueryParameter $AdditionalParameters
        }
    } else {
        $QueryParameters = [ordered] @{
            search         = $Search
            include        = $Include
            exclude        = $Exclude
            order          = $Order
            orderby        = $OrderBy
            slug           = $Slug
            context        = $Context
            status         = $Status
            media_type     = $MediaType
            mime_type      = $MimeType
            parent         = $Parent
            parent_exclude = $ParentExclude
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
        Invoke-WordpressRestApi -PrimaryUri $Authorization.Url -Uri 'wp-json/wp/v2/media' -QueryParameter $QueryParameters -Headers $Authorization.Header
    }
}
