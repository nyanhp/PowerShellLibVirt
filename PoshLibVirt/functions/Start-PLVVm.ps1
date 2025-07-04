﻿function Start-PLVVm
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
                Get-PLVVm -VmName $name
            }
        }

        foreach ($machine in $Computer.Where( { $_.PowerState -ne 'Running' }))
        {
            if (-not $PSCmdlet.ShouldProcess($machine.Name, (Get-PSFLocalizedString -Module PoshLibVirt -Name Verbose.StartVm)))
            {
                continue
            }

            sudo virsh start $machine.Uuid
        }
    }
}
