function Get-Vm
{
    [OutputType([PoshLibVirt.VirtualMachine])]
    [CmdletBinding(DefaultParameterSetName='List')]
    param
    (
        [Parameter(ParameterSetName='List')]
        [string[]]
        $ComputerName = '*',

        [Parameter(ParameterSetName='All')]
        [switch]
        $All
    )

    [string[]] $allVm = virsh list --name --all | Where-Object {-not [string]::IsNullOrWhiteSpace($_)} | Foreach-Object {$_.Trim()}
    [string[]] $runningVm = virsh list --name | Where-Object {-not [string]::IsNullOrWhiteSpace($_)} | Foreach-Object {$_.Trim()}
    foreach ($name in $ComputerName)
    {
        $vm = $allVm | Where-Object { $_ -like $name -or $All.IsPresent }
        $vmObject = [PoshLibVirt.VirtualMachine]::new()

        if (-not $vm)
        {
            Write-PSFMessage -String Error.VmNotFound -StringValues $name
            continue
        }

        [xml] $vmInfo = virsh dumpxml $vm 2>$null
        $vmObject.Name = $vmInfo.domain.name
        $vmObject.PowerState = if ($runningVm -contains $vm) { 'Running' } else { 'Stopped' }
        $vmObject.Title = $vmInfo.domain.title
        $vmObject.Uuid = $vmInfo.domain.uuid
        $vmObject.Memory = [long]$vmInfo.domain.memory.InnerText * 1kb
        $vmObject.CurrentMemory = [long]$vmInfo.domain.currentMemory.InnerText * 1kb

        $vmObject.Storage = foreach ($disk in ($vmInfo.SelectNodes('/domain/devices/disk').Where( { $_.device -eq 'disk' })))
        {
            Get-StoragePool | Get-StorageVolume | Where-Object { $_.Path -eq $disk.source.file }
        }

        $vmObject.Network = foreach ($nic in ($vmInfo.SelectNodes('/domain/devices/interface')))
        {
            [PoshLibVirt.NetworkConfiguration]::new()
        }

        $vmObject
    }
}