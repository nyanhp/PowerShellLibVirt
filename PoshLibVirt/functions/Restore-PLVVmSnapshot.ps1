function Restore-PLVVmSnapshot
{
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Low')]
    param
    (
        [Parameter(Mandatory, ParameterSetName = 'NameName', ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [Parameter(Mandatory, ParameterSetName = 'NameStart', ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [Parameter(Mandatory, ParameterSetName = 'NameSuspend', ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [Parameter(Mandatory, ParameterSetName = 'NameCurrent', ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string[]]
        $VmName,

        [Parameter(Mandatory, ParameterSetName = 'ObjectName', ValueFromPipeline)]
        [Parameter(Mandatory, ParameterSetName = 'ObjectStart', ValueFromPipeline)]
        [Parameter(Mandatory, ParameterSetName = 'ObjectSuspend', ValueFromPipeline)]
        [Parameter(Mandatory, ParameterSetName = 'ObjectCurrent', ValueFromPipeline)]
        [PoshLibVirt.VirtualMachine[]]
        $Computer,

        [Parameter(Mandatory, ParameterSetName = 'NameName')]
        [Parameter(Mandatory, ParameterSetName = 'ObjectName')]
        [Parameter(Mandatory, ParameterSetName = 'NameStart')]
        [Parameter(Mandatory, ParameterSetName = 'ObjectStart')]
        [Parameter(Mandatory, ParameterSetName = 'NameSuspend')]
        [Parameter(Mandatory, ParameterSetName = 'ObjectSuspend')]
        [string]
        $Name,

        [Parameter(Mandatory, ParameterSetName = 'NameCurrent')]
        [Parameter(Mandatory, ParameterSetName = 'ObjectCurrent')]
        [switch]
        $Current,

        [Parameter(ParameterSetName = 'NameSuspend')]
        [Parameter(ParameterSetName = 'ObjectSuspend')]
        [switch]
        $Suspend,

        [Parameter(ParameterSetName = 'NameStart')]
        [Parameter(ParameterSetName = 'ObjectStart')]
        [switch]
        $Start,

        [Parameter(ParameterSetName = 'NameName')]
        [Parameter(ParameterSetName = 'ObjectName')]
        [Parameter(ParameterSetName = 'NameStart')]
        [Parameter(ParameterSetName = 'ObjectStart')]
        [Parameter(ParameterSetName = 'NameSuspend')]
        [Parameter(ParameterSetName = 'ObjectSuspend')]
        [Parameter(ParameterSetName = 'NameCurrent')]
        [Parameter(ParameterSetName = 'ObjectCurrent')]
        [switch]
        $Force
    )

    process
    {
        if (-not $Computer)
        {
            $Computer = foreach ($vmName in $VmName)
            {
                Get-PLVVm -VmName $vmName
            }
        }

        foreach ($machine in $Computer)
        {
            if (-not $PSCmdlet.ShouldProcess($machine.Name, (Get-PSFLocalizedString -Module PoshLibVirt -Name Verbose.Restore)))
            {
                continue
            }

            $cmdLine = @(
                'snapshot-revert'
                "--domain $($machine.Name)"
                if ($Name) { "--snapshotname $Name" }
                if ($Current.IsPresent) { '--current' }
                if ($Start.IsPresent) { '--running' }
                if ($Suspend.IsPresent) { '--paused' }
                if ($FOrce.IsPresent) { '--force' }
            )

            sudo virsh @cmdLine
        }
    }
}
