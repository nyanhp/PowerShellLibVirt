function Get-VirtualNetwork
{
    [OutputType([PoshLibVirt.NetworkConfiguration])]
    [CmdletBinding()]
    param
    (
        [string[]]
        $Name = '*'
    )

    foreach ($network in (virsh net-list --all --name))
    {
        if ([string]::IsNullOrWhiteSpace($network)) { continue }
        $network = $network.Trim()
        foreach ($networkName in $Name)
        {
            if ($network -notlike $networkName) { continue }

            [xml] $networkInfo = virsh net-dumpxml $network
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
