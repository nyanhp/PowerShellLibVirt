Register-PSFTeppScriptblock -Name PoshLibVirt.OsVariant -ScriptBlock {
    osinfo-query os --fields=short-id | Select-Object -Skip 1 | % { $_.Trim() }
}

Register-PSFTeppScriptblock -Name PoshLibVirt.OsType -ScriptBlock {
    'linux', 'windows'
}

Register-PSFTeppScriptblock -Name PoshLibVirt.HyperVisorType -ScriptBlock {
    $caps = [xml](virsh capabilities)
    $caps.capabilities.guest.Where( { $_.arch.wordsize -eq 64 }).arch.domain.type
}

Register-PSFTeppScriptblock -Name PoshLibVirt.CpuModel -ScriptBlock {
    virsh cpu-models x86_64 | % { $_.Trim() }
}

Register-PSFTeppScriptblock -Name PoshLibVirt.AdapterName -ScriptBlock {
    nmcli -g DEVICE device status | % { $_.Trim() }
}

Register-PSFTeppScriptblock -Name PoshLibVirt.BridgeName -ScriptBlock {
    (bridge -j link show | ConvertFrom-Json).master
}

Register-PSFTeppScriptblock -Name PoshLibVirt.Vm -ScriptBlock {
    (Get-Vm -All).Name
}