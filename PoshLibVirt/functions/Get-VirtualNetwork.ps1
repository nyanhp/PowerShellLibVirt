﻿function Get-VirtualNetwork
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
            # TODO TODO
            $networkObject.Type = $networkInfo.network.type
            $networkObject.Capacity = $networkInfo.network.capacity.InnerText
            $networkObject.AvailableBytes = $networkInfo.network.available.InnerText
            $networkObject.AllocatedBytes = $networkInfo.network.allocation.InnerText
            $networkObject.TargetPath = $networkInfo.network.target.path
            $networkObject.Name = $networkInfo.network.name
            $networkObject.Uuid = $networkInfo.network.uuid
            $networkObject
        }
    }
}
