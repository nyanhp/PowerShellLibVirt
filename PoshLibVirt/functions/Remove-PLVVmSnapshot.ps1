function Remove-PLVVmSnapshot
{
    [CmdletBinding(DefaultParameterSetName='ObjectCurrent', SupportsShouldProcess)]
    param
    (
        # Name of the VM, supports wildcards
        [Parameter(Mandatory, ParameterSetName = 'Name', ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [Parameter(Mandatory, ParameterSetName = 'NameCurrent', ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string[]]
        $VmName,

        # Piped VM object
        [Parameter(Mandatory, ParameterSetName = 'Object', ValueFromPipeline)]
        [Parameter(Mandatory, ParameterSetName = 'ObjectCurrent', ValueFromPipeline)]
        [PoshLibVirt.VirtualMachine[]]
        $Computer,

        # Snapshot name
        [Parameter(ParameterSetName = 'Name')]
        [Parameter(ParameterSetName = 'Object')]
        [string]
        $Name = '*',

        [Parameter(ParameterSetName = 'NameCurrent')]
        [Parameter(ParameterSetName = 'ObjectCurrent')]
        [switch]
        $Current
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
                if (-not $PSCmdlet.ShouldProcess($machine.Name, (Get-PSFLocalizedString -Module PoshLibVirt -Name Verbose.Remove)))
                {
                    continue
                }
    
                $cmdLine = @(
                    'snapshot-delete'
                    "--domain $($machine.Name)"
                    if ($Name) { "--snapshotname $Name" }
                    if ($Current.IsPresent) { '--current' }
                )
    
                Start-Process -FilePath virsh -ArgumentList $cmdLine -Wait
            }
        }
    }
}