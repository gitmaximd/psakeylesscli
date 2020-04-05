function Invoke-EnvVariablesBootstrap {
    [CmdletBinding()]
    param (
        # Parameter help description
        [Parameter(Mandatory = $true)]
        [hashtable]
        $KeyValue
    )
    
    $KeyValue | ForEach-Object {
        [System.Environment]::SetEnvironmentVariable($_.Keys, $_.Values)
    }
}