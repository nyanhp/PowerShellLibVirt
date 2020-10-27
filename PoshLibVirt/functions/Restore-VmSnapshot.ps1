function Checkpoint-Vm
{
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Low')]
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

    process
    {
        if (-not $Computer)
        {
            $Computer = foreach ($name in $ComputerName)
            {
                Get-Vm -ComputerName $name
            }
        }

        foreach ($machine in $Computer)
        {
            if (-not $PSCmdlet.ShouldProcess($machine.Name, (Get-PSFLocalizedString -Module PoshLibVirt -Name Verbose.Restore)))
            {
                continue
            }

            virsh snapshot-restore --domain $Computer.Name $Name
        }
    }
}
