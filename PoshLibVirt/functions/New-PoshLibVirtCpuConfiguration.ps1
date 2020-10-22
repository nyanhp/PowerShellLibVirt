function New-PoshLibVirtCpuConfiguration
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
    
    $classParameters = Clear-PSBoundParameters -ParameterDictionary $PSBoundParameters
    [PoshLibVirtCpuConfiguration]$classParameters
}
