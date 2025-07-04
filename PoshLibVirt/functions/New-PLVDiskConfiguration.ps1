﻿function New-PLVDiskConfiguration
{
    [OutputType([PoshLibVirt.DiskConfiguration])]
    [CmdletBinding()]
    param
    (
        [string]
        $Path,

        [string]
        $StoragePoolName,

        [string]
        $Volume,

        [ValidateSet('cdrom', 'disk', 'floppy')]
        [string]
        $Device = 'disk',

        [uint64]
        $Size,

        [ValidateSet('rw', 'ro', 'sh')]
        [string]
        $Permission,

        [bool]
        $Sparse = $true,

        [ValidateSet('none', 'writethrough', 'writeback')]
        [string]
        $CacheMode = 'writethrough',

        [ValidateSet('raw', 'bochs', 'cloop', 'cow', 'dmg', 'iso', 'qcow', 'qcow2', 'qed', 'vmdk', 'vpc')]
        [string]
        $Format = 'qcow2'
    )

    $classParameters = Clear-PSBoundParameters -ParameterDictionary $PSBoundParameters
    [PoshLibVirt.DiskConfiguration]$classParameters
}
