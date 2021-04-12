function Connect-Wordpress {
    [cmdletBinding(DefaultParameterSetName = 'Password')]
    param(
        [Parameter(ParameterSetName = 'ClearText')]
        [string] $UserName,
        [Parameter(ParameterSetName = 'ClearText')]
        [string] $Password,

        [Parameter(ParameterSetName = 'ClearText')]
        [Parameter(ParameterSetName = 'Password')]
        [alias('Uri')][Uri] $Url,
        [Parameter(ParameterSetName = 'Password')]
        [pscredential] $Credential
    )
    if ($Username -and $Password) {
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
        Url    = "$Url/wp-json/wp/v2/"
    }
    $Auth
}