function New-PLVStoragePool
{
    param
    (
        [PoshLibVirt.PoolType] $Type,
        [string] $Name,
        [Guid] $Uuid,
        [ulong] $Capacity,
        [ulong] $AllocatedBytes,
        [ulong] $AvailableBytes,
        [string] $TargetPath,
        [switch] $AutoStart
    )


    $classParameters = Clear-PSBoundParameters -ParameterDictionary $PSBoundParameters
    [PoshLibVirt.StoragePool]$classParameters
}