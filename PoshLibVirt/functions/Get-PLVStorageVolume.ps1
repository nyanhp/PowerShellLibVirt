<#
.SYNOPSIS
    Get information about storage volumes
.DESCRIPTION
    Get information about storage volumes in a storage pool
.PARAMETER WhatIf
    Indicates that action should be simulated
.PARAMETER Confirm
    Indicates that a confirmation is requested
.EXAMPLE
    Get-PLVStoragePool *Noodle* | Get-PLVStorageVolume

    List all volumes in all pools with a name like Noodle
#>
function Get-PLVStorageVolume
{
    [OutputType([PoshLibVirt.StorageVolume])]
    [CmdletBinding(DefaultParameterSetName = 'Pool')]
    param
    (
        # Name of the storage pool
        [Parameter(Mandatory, ValueFromPipeline, ParameterSetName='PoolName')]
        [string]
        $PoolName,

        # Piped storage pool object
        [Parameter(Mandatory, ValueFromPipeline, ParameterSetName='Pool')]
        [PoshLibVirt.StoragePool]
        $Pool,

        # Name of the volume. Supports wildcards
        [string[]]
        $Name = '*'
    )

    process
    {
        if ($Pool) {$PoolName = $Pool.Name}

        if (-not (Get-PLVStoragePool -Name $PoolName))
        {
            Write-PSFMessage -String Error.PoolNotFound -StringValues $PoolName
            return
        }

        foreach ($vol in  (virsh vol-list --pool $PoolName | Select-Object -Skip 2)) # Why the flying F is this so counterintuitive?
        {
            if ([string]::IsNullOrWhiteSpace($vol)) { continue }
            $volName, $volPath = ($vol.Trim() -split '\s+').Trim()

            foreach ($volume in $Name)
            {
                if ($volName -notlike $volume) { continue }
                [xml] $volXml = virsh vol-dumpxml --pool $PoolName $volName

                $volObject = [PoshLibVirt.StorageVolume]::new()
                $volObject.Name = $volXml.volume.name
                $volObject.Key = $volXml.volume.key
                $volObject.Capacity = $volXml.volume.capacity.InnerText
                $volObject.AllocatedBytes = $volXml.volume.allocation.InnerText
                $volObject.PhysicalBytes = $volXml.volume.physical.InnerText
                $volObject.Pool = Get-PLVStoragePool -Name $PoolName
                $volObject.Path = $volXml.volume.target.path
                $volObject
            }
        }
    }
}