<#
.SYNOPSIS
    List all snapshots of a VM
.DESCRIPTION
    List all snapshots of a VM
.PARAMETER WhatIf
    Indicates that action should be simulated
.PARAMETER Confirm
    Indicates that a confirmation is requested
.EXAMPLE
    Get-PLVVm | Get-PLVVmSnapshot -Name BeforeDestruction

    List all snapshots called BeforeDestruction of all VMs
#>
function Get-PLVVmSnapshot
{
    [OutputType([PoshLibVirt.Snapshot])]
    [CmdletBinding(DefaultParameterSetName='Computer')]
    param
    (
        # Name of the VM, supports wildcards
        [Parameter(Mandatory, ParameterSetName = 'Name', ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string[]]
        $VmName,

        # Piped VM object
        [Parameter(Mandatory, ParameterSetName = 'Object', ValueFromPipeline)]
        [PoshLibVirt.VirtualMachine[]]
        $Computer,

        # Snapshot name
        [Parameter(ParameterSetName = 'Name')]
        [Parameter(ParameterSetName = 'Object')]
        [string]
        $Name = '*'
    )

    process
    {
        if (-not $Computer)
        {
            $Computer = foreach ($vmName in $VmName)
            {
                Get-PLVVm -ComputerName $vmName
            }
        }

        foreach ($machine in $Computer)
        {
            [string[]]$snappies = virsh snapshot-list --name --domain $machine.Name 2>$null | Where-Object { -not [string]::IsNullOrWhiteSpace($_) } | ForEach-Object { $_.Trim() }
            foreach ($snap in ($snappies -like $Name))
            {
                [xml] $snapXml = virsh snapshot-dumpxml --domain $machine.Name $snap
                [PoshLibVirt.Snapshot]::new(
                    $snapXml.domainsnapshot.name,
                    $snapXml.domainsnapshot.description,
                    $snapXml.domainsnapshot.state,
                    $snapXml.domainsnapshot.creationTime
                )
            }
        }
    }
}
