Import-Module $PSScriptRoot\..\PSWordPress.psd1 -Force

# Build credentials object for automation or simply do Get-Credential
$SecurePassword = ConvertTo-SecureString -String '01000000d08c9ddf0115d1118c7a00c04fc297eb01000000b097b77a31ba66459ff93f9d4c6ff7230000000002000000000003660000c000000010000000a538851b69af1543cfcf67bb78e4ed990000000004800000a000000010000000e8b1946cd7316a6668efc759385d03a7400000005b730cc9cbb1ab2c1fda426e71b2cfd68c6b66ec0f1fb895f0af132df3feddd6494237064bc7469d0ccc34655c579585c88f376c702ffbfeba0eea53d7bfa36c14000000f20d8b0686321544ff2ca62f21fc8c28fa86c672'
$Credentials = [System.Management.Automation.PSCredential]::new('PowerShell', $SecurePassword)
# Authorize to Wordpress
$Authorization = Connect-Wordpress -Credential $Credentials -Url 'https://evotec.xyz/'

# List posts (default 10) with specifc status and in context edit (so we can see what's set in values rather then only rendered content)
$List = Get-WordPressPage -Authorization $Authorization -Verbose -Status draft, publish -Context edit
$List | Format-Table id, date, modified, status, title

$SpecialPost = $List | Where-Object { $_.id -eq 16904 }
$SpecialPost | Format-Table
$SpecialPost.content | Format-Table

# we will use same content as in the special post to update another page
$CurrenagePageChanged = Set-WordPressPage -Authorization $Authorization -Title 'Updated Page' -Id 16954 -Content $SpecialPost.content.raw -Verbose
$CurrenagePageChanged.content | Format-Table