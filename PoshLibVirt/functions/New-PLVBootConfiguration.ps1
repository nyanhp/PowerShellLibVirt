function New-PLVBootConfiguration
{
    [OutputType([PoshLibVirt.BootConfiguration])]
    [CmdletBinding(DefaultParameterSetName='NoKernel')]
    param
    (
        [Parameter(ParameterSetName = 'NoKernel')]
        [Parameter(ParameterSetName = 'Kernel')]
        [string[]]
        $BootDevices,

        [Parameter(Mandatory, ParameterSetName = 'Kernel')]
        [string]
        $Kernel,

        [Parameter(ParameterSetName = 'Kernel')]
        [string]
        $KernelArguments,

        [Parameter(Mandatory, ParameterSetName = 'Kernel')]
        [string]
        $InitialRamDisk,

        [Parameter(ParameterSetName = 'NoKernel')]
        [Parameter(ParameterSetName = 'Kernel')]
        [bool]
        $BiosMenuEnabled
    )

    $classParameters = Clear-PSBoundParameters -ParameterDictionary $PSBoundParameters
    [PoshLibVirt.BootConfiguration]$classParameters
}
