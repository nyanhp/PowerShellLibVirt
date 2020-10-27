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

        foreach ($machine in $Computer)
        {
            if (-not $PSCmdlet.ShouldProcess($machine.Name,(Get-PSFLocalizedString -Module PoshLibVirt -Name Verbose.RebootVm)))
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