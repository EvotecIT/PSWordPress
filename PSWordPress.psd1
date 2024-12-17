@{
    AliasesToExport      = @()
    Author               = 'Przemyslaw Klys'
    CmdletsToExport      = @()
    CompanyName          = 'Evotec'
    CompatiblePSEditions = @('Desktop', 'Core')
    Copyright            = '(c) 2011 - 2024 Przemyslaw Klys @ Evotec. All rights reserved.'
    Description          = 'Module that allows interacting with WordPress via its Rest API'
    FunctionsToExport    = @('Connect-Wordpress', 'Get-WordPressCategory', 'Get-WordPressPage', 'Get-WordPressPost', 'Get-WordPressSetting', 'Get-WordPressTag', 'New-WordPressPage', 'New-WordPressPost', 'Remove-WordPressPage', 'Remove-WordPressPost', 'Set-WordPressPage', 'Set-WordPressPost', 'Set-WordPressSetting')
    GUID                 = '412368da-4507-447c-8525-5cf7628b7ae6'
    ModuleVersion        = '0.0.3'
    PowerShellVersion    = '5.1'
    PrivateData          = @{
        PSData = @{
            IconUri    = 'https://evotec.xyz/wp-content/uploads/2021/04/WordPressLogo.png'
            ProjectUri = 'https://github.com/EvotecIT/PSWordPress'
            Tags       = @('Windows', 'MacOS', 'Linux', 'Wordpress')
        }
    }
    RequiredModules      = @(@{
            Guid          = 'ee272aa8-baaa-4edf-9f45-b6d6f7d844fe'
            ModuleName    = 'PSSharedGoods'
            ModuleVersion = '0.0.302'
        })
    RootModule           = 'PSWordPress.psm1'
}