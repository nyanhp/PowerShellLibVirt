Register-PSFTeppArgumentCompleter -Command New-PLVVm -Parameter OsVariant -Name PoshLibVirt.OsVariant
Register-PSFTeppArgumentCompleter -Command New-PLVVm -Parameter HypervisorType -Name PoshLibVirt.HyperVisorType
Register-PSFTeppArgumentCompleter -Command New-PLVCpuConfiguration -Parameter Model -Name PoshLibVirt.CpuModel
Register-PSFTeppArgumentCompleter -Command New-PLVNetworkBridge -Parameter AdapterName -Name PoshLibVirt.AdapterName
Register-PSFTeppArgumentCompleter -Command New-PLVNetworkBridge,Get-PLVNetworkBridge,Remove-PLVNetworkBridge -Parameter Name -Name PoshLibVirt.BridgeName
Register-PSFTeppArgumentCompleter -Command Start-PLVVm, Stop-PLVVm, Suspend-PLVVm, Restart-PLVVm,Checkpoint-PLVVm,Remove-PLVVm, Restore-PLVVmSnapshot, Get-PLVVmSnapshot -Parameter ComputerName -Name PoshLibVirt.Vm