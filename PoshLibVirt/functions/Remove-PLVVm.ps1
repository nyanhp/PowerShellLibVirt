function Remove-PLVVm
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

        # --remove-all-storage - Indicate that all associated storage volumes are removed
        [switch]
        $Storage,

        [switch]
        $WipeStorage,

        [switch]
        $RemoveStorageVolumeSnapshot
    )

    process
    {
        if (-not $Computer)
        {
            $Computer = foreach ($name in $VmName)
            {
                Get-PLVVm -ComputerName $name
            }
        }

        foreach ($machine in $Computer)
        {
            if (-not $PSCmdlet.ShouldProcess($machine.Name, (Get-PSFLocalizedString -Module PoshLibVirt -Name Verbose.UndefineVm)))
            {
                continue
            }

            if ($machine.PowerState -eq 'Running') { Stop-PLVVm -ComputerName $machine -Force }
            $cmdLine = @(
                'undefine'
                "--domain $($machine.Uuid)"
                if ($RemoveStorageVolumeSnapshot.IsPresent) { 'delete-storage-volume-snapshots' }
                if ($Storage.IsPresent) { '--remove-all-storage' }
                if ($WipeStorage.IsPresent) { '--wipe-storage' }
            )

            Start-Process -FilePath virsh -ArgumentList $cmdLine -Wait
        }
    }
}