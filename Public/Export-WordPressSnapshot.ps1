function Export-WordPressSnapshot {
    [cmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory)][System.Collections.IDictionary] $Authorization,
        [Parameter(Mandatory)][string] $Path,
        [ValidateSet('posts', 'pages', 'categories', 'tags', 'media')][string[]] $Collections = @('posts', 'pages', 'categories', 'tags'),
        [string[]] $Languages,
        [ValidateSet('publish', 'future', 'draft', 'pending', 'private')][string[]] $PostStatus = @('publish'),
        [ValidateSet('publish', 'future', 'draft', 'pending', 'private')][string[]] $PageStatus = @('publish'),
        [int] $RecordsPerPage = 100,
        [switch] $IncludeEmbed,
        [string[]] $Fields,
        [switch] $DownloadReferencedMedia,
        [switch] $DownloadAllMedia,
        [switch] $Force,
        [switch] $PassThru
    )

    function Save-WordPressSnapshotJson {
        param(
            [Parameter(Mandatory)][string] $FilePath,
            [Parameter(Mandatory)] $InputObject
        )

        $Directory = Split-Path -Path $FilePath -Parent
        if (-not (Test-Path -LiteralPath $Directory)) {
            $null = New-Item -Path $Directory -ItemType Directory -Force
        }
        $InputObject | ConvertTo-Json -Depth 100 | Set-Content -Path $FilePath -Encoding utf8
    }

    function Get-WordPressSnapshotReferencedUrls {
        param(
            [Parameter(Mandatory)][System.Collections.IEnumerable] $Items
        )

        $DetectedUrls = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
        $UrlPattern = 'https?://[^\s"''<>`]+'
        $ImageExtensionPattern = '\.(png|jpe?g|gif|webp|svg|bmp|tiff?|ico)(\?|$)'

        foreach ($Item in $Items) {
            $EmbeddedMedia = @($Item._embedded.'wp:featuredmedia')
            foreach ($Media in $EmbeddedMedia) {
                if ($Media.source_url) {
                    $null = $DetectedUrls.Add($Media.source_url)
                }
            }

            $CandidateText = @()
            if ($Item.content.raw) {
                $CandidateText += $Item.content.raw
            }
            if ($Item.content.rendered) {
                $CandidateText += $Item.content.rendered
            }
            if ($Item.excerpt.raw) {
                $CandidateText += $Item.excerpt.raw
            }
            if ($Item.excerpt.rendered) {
                $CandidateText += $Item.excerpt.rendered
            }
            if ($Item.yoast_head) {
                $CandidateText += $Item.yoast_head
            }

            if ($Item.yoast_head_json.og_image) {
                foreach ($Image in $Item.yoast_head_json.og_image) {
                    if ($Image.url) {
                        $null = $DetectedUrls.Add($Image.url)
                    }
                }
            }
            if ($Item.yoast_head_json.twitter_image) {
                $null = $DetectedUrls.Add($Item.yoast_head_json.twitter_image)
            }

            foreach ($Text in $CandidateText) {
                if (-not $Text) {
                    continue
                }

                $Matches = [regex]::Matches($Text, $UrlPattern)
                foreach ($Match in $Matches) {
                    $Value = $Match.Value.TrimEnd('.', ',', ';', ')', ']')
                    if ($Value -match '/wp-content/' -or $Value -match $ImageExtensionPattern) {
                        $null = $DetectedUrls.Add($Value)
                    }
                }
            }
        }

        return $DetectedUrls
    }

    if (-not $Authorization.Url) {
        Write-Error 'Export-WordPressSnapshot - Authorization has no Url entry.'
        return
    }

    $ResolvedPath = [System.IO.Path]::GetFullPath($Path)
    if (-not (Test-Path -LiteralPath $ResolvedPath)) {
        $null = New-Item -Path $ResolvedPath -ItemType Directory -Force
    } elseif (-not $Force) {
        $HasFiles = (Get-ChildItem -LiteralPath $ResolvedPath -Force -ErrorAction SilentlyContinue | Measure-Object).Count -gt 0
        if ($HasFiles) {
            Write-Error "Export-WordPressSnapshot - Path '$ResolvedPath' already contains files. Use -Force to continue."
            return
        }
    }

    $RawPath = Join-Path $ResolvedPath 'raw'
    $ReportsPath = Join-Path $ResolvedPath '_reports'
    $MediaPath = Join-Path $ResolvedPath 'media'
    $MediaDownloadPath = Join-Path $MediaPath 'downloads'
    foreach ($Directory in @($RawPath, $ReportsPath, $MediaPath, $MediaDownloadPath)) {
        if (-not (Test-Path -LiteralPath $Directory)) {
            $null = New-Item -Path $Directory -ItemType Directory -Force
        }
    }

    $LanguageList = @()
    if ($Languages -and $Languages.Count -gt 0) {
        $LanguageList += $Languages
    } else {
        $LanguageList += $null
    }

    $Summary = [ordered]@{
        generatedOn      = (Get-Date).ToString('o')
        sourceUrl        = $Authorization.Url.ToString()
        collections      = $Collections
        languages        = @()
        recordsPerPage   = $RecordsPerPage
        includeEmbed     = $IncludeEmbed.IsPresent
        files            = @()
        counts           = [ordered] @{}
        warnings         = @()
        media            = [ordered]@{
            referencedUrlCount = 0
            allMediaCount      = 0
            downloadedCount    = 0
            downloads          = @()
        }
    }

    $PostsForScan = [System.Collections.Generic.List[object]]::new()
    $PagesForScan = [System.Collections.Generic.List[object]]::new()
    $MediaForDownload = [System.Collections.Generic.List[object]]::new()

    foreach ($Language in $LanguageList) {
        $LanguageKey = if ([string]::IsNullOrWhiteSpace($Language)) { 'default' } else { $Language }
        $Summary.languages += $LanguageKey
        $Summary.counts[$LanguageKey] = [ordered] @{}
        $LanguageRawPath = Join-Path $RawPath $LanguageKey
        if (-not (Test-Path -LiteralPath $LanguageRawPath)) {
            $null = New-Item -Path $LanguageRawPath -ItemType Directory -Force
        }

        $LanguageQuery = [ordered] @{}
        if ($Language) {
            $LanguageQuery['wpml_language'] = $Language
        }

        if ($Collections -contains 'posts') {
            $Posts = @(
                Get-WordPressPost -Authorization $Authorization -Context edit -RecordsPerPage $RecordsPerPage -Status $PostStatus -Embed:$IncludeEmbed -Fields $Fields -AdditionalQuery $LanguageQuery
            )
            foreach ($Post in $Posts) {
                $PostsForScan.Add($Post)
            }
            $PostsPath = Join-Path $LanguageRawPath 'posts.json'
            Save-WordPressSnapshotJson -FilePath $PostsPath -InputObject $Posts
            $Summary.files += $PostsPath
            $Summary.counts[$LanguageKey]['posts'] = $Posts.Count
        }

        if ($Collections -contains 'pages') {
            $Pages = @(
                Get-WordPressPage -Authorization $Authorization -Context edit -RecordsPerPage $RecordsPerPage -Status $PageStatus -Embed:$IncludeEmbed -Fields $Fields -AdditionalQuery $LanguageQuery
            )
            foreach ($Page in $Pages) {
                $PagesForScan.Add($Page)
            }
            $PagesPath = Join-Path $LanguageRawPath 'pages.json'
            Save-WordPressSnapshotJson -FilePath $PagesPath -InputObject $Pages
            $Summary.files += $PagesPath
            $Summary.counts[$LanguageKey]['pages'] = $Pages.Count
        }

        if ($Collections -contains 'categories') {
            $Categories = @(
                Get-WordPressCategory -Authorization $Authorization -Context edit -RecordsPerPage $RecordsPerPage -AdditionalQuery $LanguageQuery
            )
            $CategoriesPath = Join-Path $LanguageRawPath 'categories.json'
            Save-WordPressSnapshotJson -FilePath $CategoriesPath -InputObject $Categories
            $Summary.files += $CategoriesPath
            $Summary.counts[$LanguageKey]['categories'] = $Categories.Count
        }

        if ($Collections -contains 'tags') {
            $Tags = @(
                Get-WordPressTag -Authorization $Authorization -Context edit -RecordsPerPage $RecordsPerPage -AdditionalQuery $LanguageQuery
            )
            $TagsPath = Join-Path $LanguageRawPath 'tags.json'
            Save-WordPressSnapshotJson -FilePath $TagsPath -InputObject $Tags
            $Summary.files += $TagsPath
            $Summary.counts[$LanguageKey]['tags'] = $Tags.Count
        }

        if ($Collections -contains 'media' -or $DownloadAllMedia) {
            $Media = @(
                Get-WordPressMedia -Authorization $Authorization -Context edit -RecordsPerPage $RecordsPerPage -AdditionalQuery $LanguageQuery
            )
            foreach ($MediaItem in $Media) {
                $MediaForDownload.Add($MediaItem)
            }
            $MediaPathForLanguage = Join-Path $LanguageRawPath 'media.json'
            Save-WordPressSnapshotJson -FilePath $MediaPathForLanguage -InputObject $Media
            $Summary.files += $MediaPathForLanguage
            $Summary.counts[$LanguageKey]['media'] = $Media.Count
        }
    }

    $ReferencedUrls = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
    if ($DownloadReferencedMedia) {
        $CombinedItems = [System.Collections.Generic.List[object]]::new()
        foreach ($Item in $PostsForScan) {
            $CombinedItems.Add($Item)
        }
        foreach ($Item in $PagesForScan) {
            $CombinedItems.Add($Item)
        }
        if ($CombinedItems.Count -gt 0) {
            $ReferencedUrls = Get-WordPressSnapshotReferencedUrls -Items $CombinedItems
        }
    }
    $Summary.media.referencedUrlCount = $ReferencedUrls.Count

    if ($DownloadAllMedia) {
        $AllMediaUrls = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
        foreach ($MediaItem in $MediaForDownload) {
            if ($MediaItem.source_url) {
                $null = $AllMediaUrls.Add($MediaItem.source_url)
            }
        }
        $Summary.media.allMediaCount = $AllMediaUrls.Count
        foreach ($Url in $AllMediaUrls) {
            $null = $ReferencedUrls.Add($Url)
        }
    }

    if ($ReferencedUrls.Count -gt 0) {
        foreach ($Url in $ReferencedUrls) {
            $DownloadInfo = [ordered] @{
                url    = $Url
                status = 'Skipped'
                target = $null
                error  = $null
            }
            try {
                $Uri = [uri] $Url
                $RelativePath = $Uri.AbsolutePath.TrimStart('/')
                if (-not $RelativePath) {
                    $RelativePath = 'index'
                }

                $TargetPath = Join-Path $MediaDownloadPath (Join-Path $Uri.Host $RelativePath)
                $TargetDirectory = Split-Path -Path $TargetPath -Parent
                if (-not (Test-Path -LiteralPath $TargetDirectory)) {
                    $null = New-Item -Path $TargetDirectory -ItemType Directory -Force
                }

                if ($PSCmdlet.ShouldProcess($Url, "Download media to $TargetPath")) {
                    Invoke-WebRequest -Uri $Url -OutFile $TargetPath -ErrorAction Stop
                    $DownloadInfo.status = 'Downloaded'
                    $DownloadInfo.target = $TargetPath
                }
            } catch {
                $DownloadInfo.status = 'Failed'
                $DownloadInfo.error = $_.Exception.Message
                $Summary.warnings += "Failed downloading ${Url}: $($_.Exception.Message)"
            }
            $Summary.media.downloads += [PSCustomObject]$DownloadInfo
        }
    }

    $Summary.media.downloadedCount = @($Summary.media.downloads | Where-Object { $_.status -eq 'Downloaded' }).Count

    $ManifestPath = Join-Path $ResolvedPath 'snapshot.manifest.json'
    Save-WordPressSnapshotJson -FilePath $ManifestPath -InputObject $Summary
    $Summary.files += $ManifestPath

    $DownloadReportPath = Join-Path $ReportsPath 'media-downloads.json'
    Save-WordPressSnapshotJson -FilePath $DownloadReportPath -InputObject $Summary.media.downloads
    $Summary.files += $DownloadReportPath

    if ($PassThru) {
        [PSCustomObject] $Summary
    }
}
