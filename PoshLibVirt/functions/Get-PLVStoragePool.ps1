<#
.SYNOPSIS
    List storage pools
.DESCRIPTION
    List storage pools
.PARAMETER WhatIf
    Indicates that action should be simulated
.PARAMETER Confirm
    Indicates that a confirmation is requested
.EXAMPLE
    Get-PLVStoragePool -Name PoolNoodle

    View details of the storage pool PoolNoodle
#>
function Get-PLVStoragePool
{

    [OutputType([PoshLibVirt.StoragePool])]
    [CmdletBinding()]
    param
    (
        # Name of the storage pool. Supports wildcards
        [string[]]
        $Name = '*'
    )

    foreach ($pool in (sudo virsh pool-list --all --name))
    {
        if ([string]::IsNullOrWhiteSpace($pool)) { continue }
        $pool = $pool.Trim()
        foreach ($poolName in $Name)
        {
            if ($pool -notlike $poolName) { continue }

            [xml] $poolInfo = sudo virsh pool-dumpxml $pool
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
