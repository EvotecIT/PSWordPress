Import-Module $PSScriptRoot\..\PSWordPress.psd1 -Force

# Build credentials object for automation or simply do Get-Credential
$SecurePassword = ConvertTo-SecureString -String '01000000d08c9ddf0115d1118c7a00c04fc297eb01000000b097b77a31ba66459ff93f9d4c6ff7230000000002000000000003660000c000000010000000a73395656a769b97f78cb9325ea6b84b0000000004800000a000000010000000b454d82939445c8382d57c049daf6c0e380000000a54f7fe5c0698eb4c2e24eca177803e0ef55a4f7da08d8049a5c0833a5751466a341a5312ec69e48d4bc072f97e5bade35d8d974bfe605f140000004c8d273e496d4ef468a3d6d8dff51cd5971b2dd0'
$Credentials = [System.Management.Automation.PSCredential]::new('PowerShell', $SecurePassword)
# Authorize to Wordpress
$Authorization = Connect-Wordpress -Credential $Credentials -Url 'https://evotec.xyz/'

New-WordPressPost -Authorization $Authorization -Verbose -Title 'This is a title' -Content '<p> This is content with large </p>'