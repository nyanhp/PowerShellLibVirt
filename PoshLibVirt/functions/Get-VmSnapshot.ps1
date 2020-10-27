function Get-VmSnapshot
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory, ParameterSetName = 'Name', ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string[]]
        $ComputerName,

        [Parameter(Mandatory, ParameterSetName = 'Object', ValueFromPipeline)]
        [PoshLibVirt.VirtualMachine[]]
        $Computer,

        [Parameter(Mandatory, ParameterSetName = 'Name')]
        [Parameter(Mandatory, ParameterSetName = 'Object')]
        [string]
        $Name
    )

    virsh snapshot-dumpxml # ?
}