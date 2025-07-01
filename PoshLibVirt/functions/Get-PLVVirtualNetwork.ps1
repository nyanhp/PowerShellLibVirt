<#
.SYNOPSIS
    List virtual network information
.DESCRIPTION
    List virtual network information
.PARAMETER WhatIf
    Indicates that action should be simulated
.PARAMETER Confirm
    Indicates that a confirmation is requested
.EXAMPLE
    Get-PLVVirtualNetwork

    List all virtual networks
#>
function Get-PLVVirtualNetwork
{
    [OutputType([PoshLibVirt.NetworkConfiguration])]
    [CmdletBinding()]
    param
    (
        # Network name, supports wildcards
        [string[]]
        $Name = '*'
    )

    foreach ($network in (sudo virsh net-list --all --name))
    {
        if ([string]::IsNullOrWhiteSpace($network)) { continue }
        $network = $network.Trim()
        foreach ($networkName in $Name)
        {
            if ($network -notlike $networkName) { continue }

            [xml] $networkInfo = sudo virsh net-dumpxml $network
            $networkObject = [PoshLibVirt.NetworkConfiguration]::new()
            $networkObject.Name = $networkInfo.network.name
            $networkObject.Uuid = $networkInfo.network.uuid
            $networkObject.BridgeName = $networkInfo.network.bridge.Name
            foreach ($address in $networkInfo.network.ip)
            {
                $networkObject.IpAddresses.Add([PoshLibVirt.IpEntry]@{
                    IpAddress = $address.address
                    NetworkMask = $address.netmask
                })
            }
            $networkObject
        }
    }
}
