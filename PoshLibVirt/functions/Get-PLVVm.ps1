<#
.SYNOPSIS
    List all VMs
.DESCRIPTION
    List all VMs
.PARAMETER WhatIf
    Indicates that action should be simulated
.PARAMETER Confirm
    Indicates that a confirmation is requested
.EXAMPLE
    Get-PLVVm -All

    List all VMs. Can also use Get-PLVVm without any parameters
#>
function Get-PLVVm {
    [OutputType([PoshLibVirt.VirtualMachine])]
    [CmdletBinding()]
    param
    (
        # VM names to retrieve, supports Wildcards
        [Parameter()]
        [string[]]
        $VmName = '*'
    )

    [string[]] $allVm = sudo virsh list --name --all | Where-Object { -not [string]::IsNullOrWhiteSpace($_) } | Foreach-Object { $_.Trim() }
    [string[]] $runningVm = sudo virsh list --name | Where-Object { -not [string]::IsNullOrWhiteSpace($_) } | Foreach-Object { $_.Trim() }
    if ($VmName -ne '*') {
        $allVm = $allVm | Where-Object { $_ -in $VmName }
    }

    foreach ($vm in $allVm) {
        $vmObject = [PoshLibVirt.VirtualMachine]::new()

        [xml] $vmInfo = sudo virsh dumpxml $vm 2>$null
        $vmObject.Name = $vmInfo.domain.name
        $vmObject.PowerState = if ($runningVm -contains $vm) { 'Running' } else { 'Stopped' }
        $vmObject.Title = $vmInfo.domain.title
        $vmObject.Uuid = $vmInfo.domain.uuid
        $vmObject.Memory = [long]$vmInfo.domain.memory.InnerText * 1kb
        $vmObject.CurrentMemory = [long]$vmInfo.domain.currentMemory.InnerText * 1kb
        $vmObject.CpuConfiguration = if ($vmInfo.domain.cpu.mode -eq 'host-passthrough') {
            [PoshLibVirt.CpuConfiguration]@{
                IsHostCpu = $true
            }
        }
        elseif ($vmInfo.domain.cpu.mode -eq 'custom') {
            $vmObject.CpuConfiguration = [PoshLibVirt.CpuConfiguration]@{
                IsHostCpu        = $false
                Model            = $vmInfo.domain.cpu.model.'#text'
                EnabledFeatures  = ($vmInfo.domain.cpu.feature | Where-Object policy -in 'require', 'optional').name
                DisabledFeatures = ($vmInfo.domain.cpu.feature | Where-Object policy -in 'disable', 'forbid').name
            }
        }

        $vmObject.Storage = foreach ($disk in ($vmInfo.SelectNodes('/domain/devices/disk').Where( { $_.device -eq 'disk' }))) {
            $path = Split-Path -Path $disk.source.file -Parent
            $volumeName = Split-Path -Path $disk.source.file -Leaf
            Get-PLVStoragePool | Where-Object TargetPath -eq $path | Get-PLVStorageVolume -Name $volumeName
        }

        $vmObject.Network = foreach ($nic in ($vmInfo.SelectNodes('/domain/devices/interface'))) {
            Get-PLVVirtualNetwork -Name $nic.source.network
        }

        $vmObject
    }
}