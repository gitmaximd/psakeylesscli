function Get-AKLStaticSecrets {
    [CmdletBinding()]
    param (
        # Parameter help description
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]
        $Path
    )
    
    if ($PSBoundParameters.ContainsKey('Path')) {
        $cmd =  "akeyless list-items --path $Path --type static-secret"
    }
    else {
        $cmd =  "akeyless list-items --type static-secret"
    }
    Invoke-Expression -Command $cmd -ErrorVariable err -OutVariable out 2>&1 | Out-Null

    if ($err) {
        Write-Output ("Failed retrieving static secrets. Exception: {0}" -f $err.Exception.Message)
    }
    else {
        $result = ($out | ConvertFrom-Json).items
        return $result
    }
}
