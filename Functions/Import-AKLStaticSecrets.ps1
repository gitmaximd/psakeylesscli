param (
    # Parameter help description
    [Parameter(Mandatory = $true)]
    [ValidateScript({ Test-Path -Path $_ -PathType Leaf})]
    [string]
    $SecretsFile,
    
    # Parameter help description
    [Parameter()]
    [string]
    $Location
)

function Import-AKLStaticSecrets {
    [CmdletBinding()]
    param (
        # Parameter help description
        [Parameter(Mandatory = $true)]
        [ValidateScript({ Test-Path -Path $_ -PathType Leaf})]
        [string]
        $SecretsFile,
        
        # Parameter help description
        [Parameter()]
        [string]
        $Location
    )
    

    $importSecrets = (Get-Content -Path $SecretsFile -Raw | ConvertFrom-Json -AsHashtable)

    foreach ($secret in $importSecrets.GetEnumerator()) {
        $timer   = [System.Diagnostics.Stopwatch]::StartNew()
        $keyName = ([string]::IsNullOrEmpty($Location)) ? $secret.Key : $("/$Location/$($secret.Key)")

        Invoke-Expression -Command "akeyless create-secret -n $keyName -v $($secret.Value)" -ErrorAction Stop -ErrorVariable err -OutVariable out 2>&1 | Out-Null
        
        if ($err) {
            $timer.Reset()
            Write-Output ("Failed creating {0} secret. Exception: {1}" -f $keyName, $err.Exception.Message)

            continue
        }
        elseif ($out) {
            $timer.Stop()
            Write-Output ("{0} successfully created in {1:N0}ms" -f $keyName, $([math]::Truncate($timer.ElapsedMilliseconds)))
            $timer.Reset()
        }
        else {
            Write-Verbose -Message ("Finished creation process for {0}" -f $keyName)
        }
        $timer.Reset()
    }
}