function Suspend-Vm
{
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Low')]
    param
    (
        [Parameter(Mandatory, ParameterSetName = 'Name', ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string[]]
        $VmName,

        [Parameter(Mandatory, ParameterSetName = 'Object', ValueFromPipeline)]
        [PoshLibVirt.VirtualMachine[]]
        $Computer
    )

    process
    {
        if (-not $Computer)
        {
            $Computer = foreach ($name in $VmName)
            {
                Get-Vm -ComputerName $name
            }
        }

        foreach ($machine in $Computer.Where( { $_.PowerState -eq 'Running' }))
        {
            if (-not $PSCmdlet.ShouldProcess($machine.Name, (Get-PSFLocalizedString -Module PoshLibVirt -Name Verbose.SaveVm)))
            {
                continue
            }

            virsh suspend $machine.Uuid
        }
    }
}
