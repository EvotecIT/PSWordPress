Import-Module $PSScriptRoot\..\PSWordPress.psd1 -Force

# Authorize to WordPress (use app password user)
$Authorization = Connect-Wordpress -Credential (Get-Credential -UserName 'PowerShell') -Url 'https://evotec.xyz/'

# Export posts/pages/taxonomies/media snapshot with language splits and referenced media download
$Snapshot = Export-WordPressSnapshot -Authorization $Authorization `
    -Path "$PSScriptRoot\..\Artefacts\Snapshot" `
    -Collections posts, pages, categories, tags, media `
    -Languages en, pl `
    -IncludeEmbed `
    -DownloadReferencedMedia `
    -Force `
    -PassThru

$Snapshot | Format-List
