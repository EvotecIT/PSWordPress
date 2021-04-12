@{
    AliasesToExport      = @()
    Author               = 'Przemyslaw Klys'
    CmdletsToExport      = @()
    CompanyName          = 'Evotec'
    CompatiblePSEditions = @('Desktop', 'Core')
    Copyright            = '(c) 2011 - 2021 Przemyslaw Klys @ Evotec. All rights reserved.'
    Description          = 'Module that allows interacting with WordPress via its Rest API'
    FunctionsToExport    = @('Connect-Wordpress', 'Get-WordPressCategory', 'Get-WordPressPage', 'Get-WordPressPost', 'Get-WordPressSetting', 'Get-WordPressTag', 'New-WordPressPost', 'Set-WordPressSetting')
    GUID                 = '412368da-4507-447c-8525-5cf7628b7ae6'
    ModuleVersion        = '0.0.1'
    PowerShellVersion    = '5.1'
    PrivateData          = @{
        PSData = @{
            Tags       = @('Windows', 'MacOS', 'Linux', 'Wordpress')
            ProjectUri = 'https://github.com/EvotecIT/PSWordPress'
            IconUri    = 'https://evotec.xyz/wp-content/uploads/2021/04/WordPressLogo.png'
        }
    }
    RequiredModules      = @(@{
            ModuleVersion = '0.0.199'
            ModuleName    = 'PSSharedGoods'
            Guid          = 'ee272aa8-baaa-4edf-9f45-b6d6f7d844fe'
        })
    RootModule           = 'PSWordPress.psm1'
}