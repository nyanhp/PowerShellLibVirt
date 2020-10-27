function Get-NetworkBridge
{
    [CmdletBinding()]
    param
    (
        [string]
        $Name = '*'
    )

    ip -j link show type bridge | ConvertFrom-Json | Where-Object ifname -like $Name
}
