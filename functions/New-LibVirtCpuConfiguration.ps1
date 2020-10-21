function New-LibVirtCpuConfiguration
{
    [CmdletBinding(DefaultParameterSetName = 'Model')]
    param
    (
        [Parameter(Mandatory, ParameterSetName = 'Model')]
        [string] 
        $Model,

        [Parameter(ParameterSetName = 'Model')]
        [string[]] 
        $EnabledFeature,

        [Parameter( ParameterSetName = 'Model')]
        [string[]] 
        $DisabledFeature,

        [Parameter(Mandatory, ParameterSetName = 'Host')]
        [switch]
        $IsHostCpu
    )

    $cpuConfig = [LibVirtCpuConfiguration]::new()

    if ($IsHostCpu.IsPresent)
    {
        $cpuConfig.IsHostCpu = $true
        return $cpuConfig
    }
    
    $cpuConfig.Model = $Model
    $cpuConfig.EnabledFeatures = $EnabledFeature
    $cpuConfig.DisabledFeatures = $DisabledFeature
    $cpuConfig
}
