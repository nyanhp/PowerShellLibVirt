<#
.SYNOPSIS
    Create a VM snapshot
.DESCRIPTION
    Create a VM snapshot
.EXAMPLE
    Get-Vm | Checkpoint-Vm

    Create snapshots of all running VMs
.PARAMETER WhatIf
    Indicates that action should be simulated
.PARAMETER Confirm
    Indicates that a confirmation is requested
#>
function Checkpoint-Vm
{
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Low')]
    param
    (
        # The hosts to create a snapshot of
        [Parameter(Mandatory, ParameterSetName = 'Name', ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string[]]
        $VmName,

        # The VirtualMachine object to create a snapshot of
        [Parameter(Mandatory, ParameterSetName = 'Object', ValueFromPipeline)]
        [PoshLibVirt.VirtualMachine[]]
        $Computer,

        # The snapshot name
        [Parameter(Mandatory, ParameterSetName = 'Name')]
        [Parameter(Mandatory, ParameterSetName = 'Object')]
        [string]
        $Name,

        # The snapshot description
        [string]
        $Description,

        # Indicates that metadata should not be included
        [switch]
        $NoMetaData,

        # Indicates that the VM should be stopped
        [switch]
        $StopVm,

        # Indicates that only a storage snapshot is created
        [switch]
        $DiskOnly,

        # Indicates something
        [switch]
        $ReuseExternal,

        # Indicates something
        [switch]
        $Atomic,

        # Indicates that snapshot is taken from a running system
        [switch]
        $Live
    )

    process
    {
        if (-not $Computer)
        {
            $Computer = foreach ($vmName in $VmName)
            {
                Get-Vm -ComputerName $vmName
            }
        }

        foreach ($machine in $Computer)
        {
            if (-not $PSCmdlet.ShouldProcess($machine.Name, (Get-PSFLocalizedString -Module PoshLibVirt -Name Verbose.Checkpoint)))
            {
                continue
            }

            $cmdLine = @(
                'snapshot-create-as'
                "--domain $($machine.Uuid)"
                "--name $Name"
                if (-not [string]::IsNullOrWhiteSpace($Description)) { "--description `"$Description`"" }
                if ($NoMetaData.IsPresent()) { '--no-metadata' }
                if ($StopVm.IsPresent()) { '--halt' }
                if ($DiskOnly.IsPresent()) { '--disk-only' }
                if ($ReuseExternal.IsPresent()) { '--reuse-external' }
                if ($Atomic.IsPresent()) { '--atomic' }
                if ($Live.IsPresent()) { '--live' }
            )

            Start-Process -Wait -FilePath virsh -ArgumentList $cmdLine
        }
    }
}
