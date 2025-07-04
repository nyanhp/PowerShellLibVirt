﻿function Restart-PLVVm
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

        # Indicates reset instead of reboot.
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

        foreach ($machine in $Computer)
        {
            if (-not $PSCmdlet.ShouldProcess($machine.Name,(Get-PSFLocalizedString -Module PoshLibVirt -Name Verbose.RebootVm)))
            {
                continue
            }

            if ($Force.IsPresent)
            {
                sudo virsh reset $machine.Uuid
                continue
            }

            sudo virsh reboot $machine.Uuid
        }
    }
}