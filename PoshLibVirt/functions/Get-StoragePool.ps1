function Get-StoragePool
{
    [CmdletBinding()]
    param
    (
        [string[]]
        $Name = '*'
    )

    foreach ($pool in (virsh pool-list --all --name))
    {
        if ([string]::IsNullOrWhiteSpace($pool)) { continue }
        $pool = $pool.Trim()
        foreach ($poolName in $Name)
        {
            if ($pool -notlike $poolName) { continue }

            [xml] $poolInfo = virsh pool-dumpxml $pool
            $poolObject = [PoshLibVirt.StoragePool]::new()
            $poolObject.Type = $poolInfo.pool.type
            $poolObject.Capacity = $poolInfo.pool.capacity.InnerText
            $poolObject.AvailableBytes = $poolInfo.pool.available.InnerText
            $poolObject.AllocatedBytes = $poolInfo.pool.allocation.InnerText
            $poolObject.TargetPath = $poolInfo.pool.target.path
            $poolObject.Name = $poolInfo.pool.name
            $poolObject.Uuid = $poolInfo.pool.uuid
            $poolObject
        }
    }
}
