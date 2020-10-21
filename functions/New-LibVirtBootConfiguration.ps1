function New-LibVirtBootConfiguration
{
    [CmdletBinding(DefaultParameterSetName='NoKernel')]
    param
    (
        [Parameter(ParameterSetName = 'NoKernel')]
        [Parameter(ParameterSetName = 'Kernel')]
        [string[]]
        $BootDevice,

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
        [switch] 
        $BiosMenuEnabled
    )

    $bootConfig = [LibVirtBootConfiguration]::new()
    $bootConfig.BootDevices = $BootDevice
    $bootConfig.Kernel = $Kernel
    $bootConfig.KernelArguments = $KernelArguments
    $bootConfig.BiosMenuEnabled = $BiosMenuEnabled.IsPresent
    $bootConfig
}
