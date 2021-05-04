function Stop-Vm
{
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param
    (
        [Parameter(Mandatory, ParameterSetName = 'Name', ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string[]]
        $VmName,

        [Parameter(Mandatory, ParameterSetName = 'Object', ValueFromPipeline)]
        [PoshLibVirt.VirtualMachine[]]
        $Computer,

        # Indicates hard shutdown instead of graceful shutdown.
        [switch]
        $Force
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
            if (-not $PSCmdlet.ShouldProcess($machine.Name, (Get-PSFLocalizedString -Module PoshLibVirt -Name Verbose.StopVm)))
            {
                continue
            }

            if ($Force.IsPresent)
            {
                virsh destroy $machine.Uuid
                continue
            }

            virsh shutdown $machine.Uuid
        }
    }
}