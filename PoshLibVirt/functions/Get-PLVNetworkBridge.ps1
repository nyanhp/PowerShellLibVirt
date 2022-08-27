<#
.SYNOPSIS
    List the network bridge configuration
.DESCRIPTION
    List the network bridge configuration
.EXAMPLE
    Get-PLVNetworkBridge

    List all bridges
.PARAMETER WhatIf
    Indicates that action should be simulated
.PARAMETER Confirm
    Indicates that a confirmation is requested
#>
function Get-PLVNetworkBridge
{
    [OutputType([PoshLibVirt.NetworkBridge[]])]
    [CmdletBinding()]
    param
    (
        # Name of the bridge. Supports wilcards
        [string]
        $Name = '*'
    )

    [PoshLibVirt.NetworkBridge[]] (ip -j link show type bridge | ConvertFrom-Json | Where-Object ifname -like $Name)
}
