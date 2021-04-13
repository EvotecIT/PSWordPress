﻿function Remove-WordPressPage {
    [cmdletBinding(SupportsShouldProcess)]
    param(
        [System.Collections.IDictionary] $Authorization,
        [Parameter(Mandatory)][int] $Id,
        [switch] $Force
    )
    $QueryParameters = [ordered] @{}
    if ($Force) {
        $QueryParameters['force'] = $Force.IsPresent
    }
    Invoke-RestApi -PrimaryUri $Authorization.Url -Uri "wp-json/wp/v2/pages/$Id" -QueryParameter $QueryParameters -Headers $Authorization.Header -Method DELETE
}