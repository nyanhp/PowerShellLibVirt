function Stop-PLVVm
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
                Get-PLVVm -VmName $name
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
                sudo virsh destroy $machine.Uuid
                continue
            }

            sudo virsh shutdown $machine.Uuid
        }
    }
}