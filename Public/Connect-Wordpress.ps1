function Connect-Wordpress {
    [cmdletBinding(DefaultParameterSetName = 'Password')]
    param(
        [Parameter(ParameterSetName = 'ClearText')]
        [Parameter(ParameterSetName = 'EncryptedPassword')]
        [string] $UserName,
        [Parameter(ParameterSetName = 'ClearText')]
        [string] $Password,
        [Parameter(ParameterSetName = 'EncryptedPassword')]
        [string] $EncryptedPassword,

        [Parameter(ParameterSetName = 'EncryptedPassword')]
        [Parameter(ParameterSetName = 'ClearText')]
        [Parameter(ParameterSetName = 'Password')]
        [alias('Uri')][Uri] $Url,
        [Parameter(ParameterSetName = 'Password')]
        [pscredential] $Credential
    )
    if ($UserName -and $EncryptedPassword) {
        $UserNameApi = $UserName
        $TempPassword = ConvertTo-SecureString -String $EncryptedPassword
        $Credentials = [System.Management.Automation.PSCredential]::new($UserNameApi, $TempPassword)
        $PasswordApi = $Credentials.GetNetworkCredential().Password

    } elseif ($Username -and $Password) {
        $UserNameApi = $UserName
        $PasswordApi = $Password
    } elseif ($Credential) {
        $UserNameApi = $Credential.UserName
        $PasswordApi = $Credential.GetNetworkCredential().Password
    }
    $Authorization = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("$UserNameApi`:$PasswordApi")))
    $Auth = @{
        Header = @{
            Authorization = -join ("Basic ", $Authorization)
        }
        Url    = $Url
    }
    $Auth
}