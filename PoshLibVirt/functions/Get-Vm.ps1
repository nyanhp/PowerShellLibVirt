function Get-Vm
{
    [CmdletBinding()]
    param
    (
        [string[]]
        $ComputerName = '*'
    )

    foreach ($name in $ComputerName)
    {
        $vm = virsh list --name --all | Where-Object { $_ -like $name }

        if (-not $vm)
        {
            Write-PSFMessage -String Error.VmNotFound -StringValues $name
            continue
        }

        [xml] $vmInfo = virsh dumpxml $vm 2>$null
        
        foreach ($disk in ($vmInfo.SelectNodes('/domain/devices/disk').Where({$_.device -eq 'disk'})))
        {
            Get-StoragePool | Get-StorageVolume | Where-Object {$_.Path -eq $disk.source.file}
        }
    }
}