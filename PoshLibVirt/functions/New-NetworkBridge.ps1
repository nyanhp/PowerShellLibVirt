function New-NetworkBridge
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [string]
        $Name,

        # ip/mask
        [string]
        $IpAddress,

        [string[]]
        $AdapterName,

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
