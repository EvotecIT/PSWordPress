@{
    AliasesToExport      = @()
    Author               = 'Przemyslaw Klys'
    CmdletsToExport      = @()
    CompanyName          = 'Evotec'
    CompatiblePSEditions = @('Desktop', 'Core')
    Copyright            = '(c) 2011 - 2021 Przemyslaw Klys @ Evotec. All rights reserved.'
    Description          = 'Module that allows interacting with WordPress.'
    FunctionsToExport    = @('Connect-Wordpress', 'Get-WordPressPage', 'Get-WordPressPost', 'Get-WordPressSetting')
    GUID                 = '412368da-4507-447c-8525-5cf7628b7ae6'
    ModuleVersion        = '0.0.1'
    PowerShellVersion    = '5.1'
    PrivateData          = @{
        PSData = @{
            Tags = @('Windows', 'MacOS', 'Linux', 'Wordpress')
        }
    }
    RootModule           = 'PSWordPress.psm1'
}