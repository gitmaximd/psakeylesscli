Param (
    # Parameter help description
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string]
    $KeyPath
)

Get-ChildItem -Path (Join-Path -Path ($PSScriptRoot) -ChildPath 'Functions') -File | ForEach-Object { . $_.FullName }

Get-AKLStaticSecrets -Path $KeyPath | ForEach-Object {
    Get-AKLSecretValue -Name $_.item_name -KeyValue | ForEach-Object {
        Invoke-EnvVariablesBootstrap -KeyValue $_
    }
}