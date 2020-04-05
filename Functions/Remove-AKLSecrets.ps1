function Remove-AKLStaticSecrets {
    [CmdletBinding()]
    param (
        # Parameter help description
        [Parameter(Mandatory = $true)]
        [string[]]
        $SecretNames
    )
    
    foreach ($secret in $SecretNames) {
        Invoke-Expression -Command "akeyless delete-item --name $secret" -ErrorVariable err -OutVariable out 2>&1 | Out-Null

        if ($err) {
            Write-Output ("Failed deleting static secret {0}. Exception: {1}" -f $secret, $err.Exception.Message)
        }
        else {
            $out
        }
    }
}