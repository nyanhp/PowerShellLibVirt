function Get-NetworkBridge
{
    [OutputType([PoshLibVirt.NetworkBridge])]
    [CmdletBinding()]
    param
    (
        [string]
        $Name = '*'
    )

    [PoshLibVirt.NetworkBridge[]] (ip -j link show type bridge | ConvertFrom-Json | Where-Object ifname -like $Name)
}
