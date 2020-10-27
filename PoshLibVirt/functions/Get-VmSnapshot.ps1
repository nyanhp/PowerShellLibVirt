function Get-VmSnapshot
{
    [CmdletBinding(DefaultParameterSetName='Computer')]
    param
    (
        [Parameter(Mandatory, ParameterSetName = 'Name', ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string[]]
        $ComputerName,

        [Parameter(Mandatory, ParameterSetName = 'Object', ValueFromPipeline)]
        [PoshLibVirt.VirtualMachine[]]
        $Computer,

        [Parameter(ParameterSetName = 'Name')]
        [Parameter(ParameterSetName = 'Object')]
        [string]
        $Name = '*'
    )

    process
    {
        if (-not $Computer)
        {
            $Computer = foreach ($vmName in $ComputerName)
            {
                Get-Vm -ComputerName $vmName
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
