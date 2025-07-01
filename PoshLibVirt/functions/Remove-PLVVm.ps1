function Remove-PLVVm {
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
        $RemoveAllStorage,

        # Perform a wipe of the storage volumes before removing them
        [switch]
        $WipeStorage,

        [switch]
        $RemoveStorageVolumeSnapshot
    )

    process {
        if (-not $Computer) {
            $Computer = foreach ($name in $VmName) {
                Get-PLVVm -VmName $name
            }
        }

        foreach ($machine in $Computer) {
            if (-not $PSCmdlet.ShouldProcess($machine.Name, (Get-PSFLocalizedString -Module PoshLibVirt -Name Verbose.UndefineVm))) {
                continue
            }

            if ($machine.PowerState -eq 'Running') { Stop-PLVVm -Computer $machine -Force }
            $cmdLine = @(
                'undefine'
                "--domain"
                $($machine.Uuid)
                if ($RemoveStorageVolumeSnapshot.IsPresent) { 'delete-storage-volume-snapshots' }
                if ($RemoveAllStorage.IsPresent) { '--remove-all-storage' }
                if (-not $RemoveAllStorage.IsPresent) {
                    '--storage'
                    $machine.Storage.Path
                }
                if ($WipeStorage.IsPresent) { '--wipe-storage' }
            )

            Write-PSFMessage -Message "sudo virsh $($cmdLine -join ' ')"
            sudo virsh @cmdLine
        }
    }
}