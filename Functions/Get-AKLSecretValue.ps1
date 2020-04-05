function Get-AKLSecretValue {
    [CmdletBinding()]
    param (
        # Parameter help description
        [Parameter(Mandatory = $true)]
        [string]
        $Name,

        # Parameter help description
        [Parameter()]
        [switch]
        $KeyValue
    )

    Invoke-Expression -Command "akeyless get-secret-value --name $Name" -ErrorVariable err -OutVariable out 2>&1 | Out-Null

    if ($err) {
        Write-Output ("Failed retrieving secret value for {0}. Exception: {1}" -f $Name, $err.Exception.Message)
    }
    else {
        if ($KeyValue.IsPresent) {
            $Name   = $Name.Split('/')[-1]
            $result = @{$Name = $out[0]}
        }
        else {
            $result = $out[0]
        }
        return $result
    }
}