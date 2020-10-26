function Restart-Vm
{
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param
    (
        [Parameter(Mandatory, ParameterSetName = 'Name', ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string[]]
        $ComputerName,

        [Parameter(Mandatory, ParameterSetName = 'Object', ValueFromPipeline)]
        [PoshLibVirt.VirtualMachine[]]
        $Computer,

        # Indicates reset instead of reboot.
        [switch]
        $Force
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

        foreach ($machine in $Computer.Where( { $_.PowerState -eq 'Running' }))
        {
            if (-not $PSCmdlet.ShouldProcess('Stopping VM', $machine.Name))
            {
                continue
            }

            if ($Force.IsPresent)
            {
                virsh reset $machine.Uuid
                continue
            }

            virsh reboot $machine.Uuid
        }
    }
}