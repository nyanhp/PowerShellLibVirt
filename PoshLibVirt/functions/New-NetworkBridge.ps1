<#
.SYNOPSIS
    Create new network bridge
.DESCRIPTION
    Create new network bridge
.PARAMETER WhatIf
    Indicates that action should be simulated
.PARAMETER Confirm
    Indicates that a confirmation is requested
.EXAMPLE
    New-NetworkBridge -Name br01 -IpAddress 192.168.2.0/24 -AdapterName eth0,eth1

    Bridge eth0 and eth1 to a bridge device br01
#>
function New-NetworkBridge
{
    [CmdletBinding()]
    param
    (
        # Name of new bridge
        [Parameter(Mandatory)]
        [string]
        $Name,

        # IP address and mask combination, e.g. 192.168.2.123/24
        [string]
        $IpAddress,

        # List of adapters to add to bridge
        [string[]]
        $AdapterName,

        # Indicates that the bridge should use STP
        [switch]
        $UseSpanningTreeProtocol
    )

    if (Get-NetworkBridge -Name $Name)
    {
        Write-PSFMessage -String Error.BridgeExists -StringValues $Name
        return
    }

    $null = ip link add name $Name type bridge
    $null = ip link set $Name up

    $connections = bridge -j link | ConvertFrom-Json | Where-Object master -eq $Name
    foreach ($adapter in $AdapterName)
    {
        if ($connections | Where-Object -Property ifname -eq $adapter)
        {
            Write-PSFMessage -String Warning.BridgeConnectionExists -StringValues $Name, $adapter
            continue
        }

        $null = ip link set $adapter up
        $null = ip link set $adapter master $Name
    }

    foreach ($connection in $connections)
    {
        if ($UseSpanningTreeProtocol.IsPresent)
        {
            $null = bridge link set $connection.ifname state 3
        }
        elseif ($connections.state -ne 'disabled')
        {
            $null = bridge link set $connection.ifname state 0
        }
    }

    if ($IpAddress)
    {
        $null = ip address add dev $Name $IpAddress
    }
}
